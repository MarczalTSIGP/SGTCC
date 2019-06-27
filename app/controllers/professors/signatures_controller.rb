class Professors::SignaturesController < Professors::BaseController
  include SignatureConfirm
  before_action :set_signature, only: [:show, :confirm]
  before_action :can_view, only: :show

  add_breadcrumb I18n.t('breadcrumbs.signatures.pendings'),
                 :professors_signatures_pending_path,
                 only: :pending

  add_breadcrumb I18n.t('breadcrumbs.signatures.signeds'),
                 :professors_signatures_signed_path,
                 only: :signed

  def pending
    @signatures = current_professor.signatures_pending(params[:page])
  end

  def signed
    @signatures = current_professor.signatures_signed(params[:page])
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.signatures.show'), professors_signature_path(@signature)
  end

  def confirm
    confirm_and_sign(Professor, 'username')
  end

  private

  def set_signature
    @signature = Signature.find(params[:id])
  end

  def can_view
    return if @signature.professor_can_view(current_professor)
    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to professors_signatures_pending_path
  end
end
