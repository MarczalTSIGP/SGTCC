class SignaturesController < ApplicationController
  before_action :set_signature, only: [:code, :data]
  before_action :set_signature_code, only: [:show, :confirm_document]
  before_action :can_show, only: :show
  include JsonMessage

  def mark
    render json: Signature.mark(params[:orientation_id], params[:document_type_id])
  end

  def code
    signature_code = @signature.signature_code

    render json: {
      all_signed: signature_code.all_signed?, code: signature_code.code, link: signature_url
    }
  end

  def status
    render json: Signature.status_table(params[:orientation_id], params[:document_type_id])
  end

  def document; end

  def show
    @signature = @signature_code.signatures.first
    success_document_authenticated_message
  end

  def data
    render json: @signature.term_json_data
  end

  def confirm_document
    content = { message: document_not_found_message, status: :not_found }
    content = { message: document_authenticated_message } if @signature_code&.all_signed?

    render json: content
  end

  private

  def set_signature_code
    @signature_code = SignatureCode.find_by(code: params[:code])
  end

  def can_show
    return if @signature_code.present? && @signature_code.all_signed?
    error_document_not_found_message
    redirect_to signature_document_path
  end

  def set_signature
    @signature = Signature.find(params[:id])
  end
end
