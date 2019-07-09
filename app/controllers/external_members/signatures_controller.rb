class ExternalMembers::SignaturesController < ExternalMembers::BaseController
  include SignatureConfirm
  before_action :set_signature, only: [:show, :confirm]
  before_action :can_view, only: :show

  add_breadcrumb I18n.t('breadcrumbs.signatures.pendings'),
                 :external_members_signatures_pending_path,
                 only: :pending

  add_breadcrumb I18n.t('breadcrumbs.signatures.signeds'),
                 :external_members_signatures_signed_path,
                 only: :signed

  def pending
    @signatures = current_external_member.signatures_pending(params[:page])
  end

  def signed
    @signatures = current_external_member.signatures_signed(params[:page])
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.signatures.show'),
                   external_members_signature_path(@signature)
  end

  def confirm
    confirm_and_sign(ExternalMember, 'email')
  end

  private

  def set_signature
    @signature = current_external_member.signatures.find_by(id: params[:id])
  end

  def can_view
    return if @signature.present?
    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to external_members_signatures_pending_path
  end
end
