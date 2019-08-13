class ExternalMembers::DocumentsController < ExternalMembers::BaseController
  include SignatureConfirm
  before_action :set_document, only: [:show, :confirm]
  before_action :can_view, only: :show

  add_breadcrumb I18n.t('breadcrumbs.signatures.pendings'),
                 :external_members_documents_pending_path,
                 only: :pending

  add_breadcrumb I18n.t('breadcrumbs.signatures.signeds'),
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
    @signature = @document.signature_by_external_member(current_external_member)
  end

  def confirm
    confirm_and_sign(current_external_member, current_external_member.email)
  end

  private

  def set_document
    @document = current_external_member.documents.find_by(id: params[:id])
  end

  def can_view
    return if @document.present?
    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to external_members_documents_pending_path
  end
end
