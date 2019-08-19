class Professors::DocumentsController < Professors::BaseController
  include DocumentSignature
  before_action :set_document, only: [:show, :sign]
  before_action :can_view, only: :show
  before_action :set_signature, only: [:show, :sign]

  add_breadcrumb I18n.t('breadcrumbs.documents.reviewing'),
                 :professors_documents_reviewing_path,
                 only: :reviewing

  add_breadcrumb I18n.t('breadcrumbs.documents.pending'),
                 :professors_documents_pending_path,
                 only: :pending

  add_breadcrumb I18n.t('breadcrumbs.documents.signed'),
                 :professors_documents_signed_path,
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
    add_breadcrumb I18n.t('breadcrumbs.signatures.show'),
                   professors_document_path(@document)
  end

  def sign
    confirm_and_sign(current_professor, current_professor.username)
  end

  private

  def set_document
    @document = current_professor.documents.find_by(id: params[:id])
  end

  def set_signature
    @signature = @document.signature_by_user(current_professor.id, current_professor.user_types)
  end

  def can_view
    return if @document.present?
    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to professors_documents_pending_path
  end
end
