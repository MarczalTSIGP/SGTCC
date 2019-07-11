class DocumentsController < ApplicationController
  before_action :set_signature, only: [:code, :data]
  before_action :set_document, only: [:show, :confirm_document]
  before_action :can_show, only: :show
  include JsonMessage

  def mark
    render json: Signature.mark(params[:orientation_id], params[:document_type_id])
  end

  def code
    document = @signature.document

    render json: {
      all_signed: document.all_signed?, code: document.code, link: document_code_url
    }
  end

  def status
    render json: Signature.status_table(params[:orientation_id], params[:document_type_id])
  end

  def document; end

  def show
    @signature = @document.signatures.first
    success_document_authenticated_message
  end

  def data
    render json: @signature.term_json_data
  end

  def confirm_document
    content = { message: document_not_found_message, status: :not_found }
    content = { message: document_authenticated_message } if @document&.all_signed?

    render json: content
  end

  private

  def set_document
    @document = Document.find_by(code: params[:code])
  end

  def can_show
    return if @document.present? && @document&.all_signed?
    error_document_not_found_message
    redirect_to document_path
  end

  def set_signature
    @signature = Signature.find(params[:id])
  end
end
