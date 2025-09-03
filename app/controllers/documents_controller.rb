class DocumentsController < ApplicationController
  before_action :set_document, only: [:data, :mark, :code, :status, :request_data]
  before_action :set_document_by_code, only: [:show, :confirm_document]
  before_action :can_show, only: :show
  include JsonMessage

  def mark
    render json: @document.mark
  end

  def code
    render json: {
      all_signed: @document.all_signed?, code: @document.code, link: confirm_document_code_url
    }
  end

  def status
    render json: @document.status_table
  end

  def document; end

  def show
    @signature = @document.signatures.first
    success_document_authenticated_message
    @signatures = @document.mark
  end

  def data
    render json: @document.content
  end

  def request_data
    render json: @document.request
  end

  def confirm_document
    content = { message: document_not_found_message, status: :not_found }
    content = { message: document_authenticated_message } if @document&.all_signed?

    render json: content
  end

  def images
    helpers = ActionController::Base.helpers
    render json: { sgtcc_seal: helpers.asset_url('sgtcc_signature.png'),
                   utfpr_logo: helpers.asset_url('utfpr_logo.png') }
  end

  private

  def set_document_by_code
    @document = Document.find_by(code: params[:code])
  end

  def set_document
    @document = Document.find(params[:id])
  end

  def can_show
    return if @document.present? && @document&.all_signed?

    error_document_not_found_message
    redirect_to document_path
  end
end
