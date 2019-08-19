class ExternalMembers::DocumentsController < ExternalMembers::BaseController
  include DocumentSignature
  before_action :set_document, only: [:show, :sign]
  before_action :can_view, only: :show
  before_action :set_signature, only: [:show, :sign]

  add_breadcrumb I18n.t('breadcrumbs.documents.pending'),
                 :external_members_documents_pending_path,
                 only: :pending

  add_breadcrumb I18n.t('breadcrumbs.documents.signed'),
                 :external_members_documents_signed_path,
                 only: :signed

  def pending
    @documents = current_external_member.documents_pending(params[:page])
  end

  def signed
    @documents = current_external_member.documents_signed(params[:page])
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.signatures.show'),
                   external_members_document_path(@document)
  end

  def sign
    confirm_and_sign(current_external_member, current_external_member.email)
  end

  private

  def set_document
    @document = current_external_member.documents.find_by(id: params[:id])
  end

  def set_signature
    @signature = @document.signature_by_user(current_external_member.id,
                                             :external_member_supervisor)
  end

  def can_view
    return if @document.present?
    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to external_members_documents_pending_path
  end
end
