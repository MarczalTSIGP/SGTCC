class Academics::DocumentsController < Academics::BaseController
  include SignatureConfirm
  before_action :set_document, only: [:show, :confirm]
  before_action :can_view, only: :show

  add_breadcrumb I18n.t('breadcrumbs.signatures.pendings'),
                 :academics_documents_pending_path,
                 only: :pending

  add_breadcrumb I18n.t('breadcrumbs.signatures.signeds'),
                 :academics_documents_signed_path,
                 only: :signed

  def pending
    @documents = current_academic.documents_pending(params[:page])
  end

  def signed
    @documents = current_academic.documents_signed(params[:page])
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.signatures.show'), academics_document_path(@document)
  end

  def confirm
    confirm_and_sign(current_academic, current_academic.ra)
  end

  private

  def set_document
    @document = current_academic.documents.find_by(id: params[:id])
  end

  def can_view
    return if @document.present?
    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to academics_documents_pending_path
  end
end
