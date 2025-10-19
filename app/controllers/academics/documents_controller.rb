class Academics::DocumentsController < Academics::BaseController
  include DocumentSignature
  before_action :set_document, only: [:show, :sign, :sign_form]
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
    back_path_or_default = request.referer || academics_documents_pending_path
    add_breadcrumb I18n.t('breadcrumbs.documents.name'), back_path_or_default
    add_breadcrumb I18n.t('breadcrumbs.documents.id', id: @document.id),
                   academics_document_path(@document)

    @signatures = @document.mark
  end

  def sign_form
    add_breadcrumb I18n.t('breadcrumbs.documents.pending'), :academics_documents_pending_path
    add_breadcrumb I18n.t('breadcrumbs.documents.show'), academics_document_path(@document)
    add_breadcrumb I18n.t('breadcrumbs.documents.sign'),
                   academics_document_sign_form_path(@document)

    @username = Academic.human_attribute_name('ra')
    @confirm_url = academics_document_sign_path(@document)
    @back_url = academics_document_path(@document)
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
