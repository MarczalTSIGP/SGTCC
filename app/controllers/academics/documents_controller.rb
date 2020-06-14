class Academics::DocumentsController < Academics::BaseController
  include DocumentSignature
  before_action :set_document, only: [:show, :sign]
  before_action :can_view, only: :show
  before_action :set_signature, only: [:show, :sign]

  add_breadcrumb I18n.t('breadcrumbs.documents.pending'),
                 :academics_documents_pending_path,
                 only: :pending

  add_breadcrumb I18n.t('breadcrumbs.documents.signed'),
                 :academics_documents_signed_path,
                 only: :signed

  def pending
    @documents = current_academic.documents_pending(params[:page])
  end

  def signed
    @documents = current_academic.documents_signed(params[:page])
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.documents.show'), academics_document_path(@document)
  end

  def sign
    confirm_and_sign(current_academic, current_academic.ra)
  end

  private

  def set_document
    @document = current_academic.documents.find_by(id: params[:id])
  end

  def set_signature
    @signature = @document.signature_by_user(current_academic.id, :academic)
  end

  def can_view
    return if @document.present?

    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to academics_documents_pending_path
  end
end
