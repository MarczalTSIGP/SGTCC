class Professors::SignaturesController < Professors::BaseController
  include SignatureConfirm
  before_action :set_signature, only: [:show, :confirm]
  before_action :can_view, only: :show

  add_breadcrumb I18n.t('breadcrumbs.documents.reviewing'),
                 :professors_signatures_reviewing_path,
                 only: :reviewing

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
    @signatures = current_professor.signatures_signed(params[:page], params[:term])
  end

  def reviewing
    @signatures = current_professor.signatures_for_review(params[:page])
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.signatures.show'), professors_signature_path(@signature)
  end

  def confirm
    confirm_and_sign(current_professor, current_professor.username)
  end

  private

  def set_signature
    @signature = current_professor.signatures.find_by(id: params[:id])
  end

  def can_view
    return if @signature.present?
    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to professors_signatures_pending_path
  end
end
