class Professors::SignaturesController < Professors::BaseController
  include SignatureConfirm
  before_action :set_document, only: [:show, :confirm]
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
    @documents = current_professor.documents_pending(params[:page])
  end

  def signed
    @documents = current_professor.documents_signed(params[:page])
  end

  def reviewing
    @documents = current_professor.documents_reviewing(params[:page])
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.signatures.show'), professors_signature_path(@document)
  end

  def confirm
    confirm_and_sign(current_professor, current_professor.username)
  end

  private

  def set_document
    @document = current_professor.documents.find_by(id: params[:id])
  end

  def can_view
    return if @document.present?
    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to professors_signatures_pending_path
  end
end
