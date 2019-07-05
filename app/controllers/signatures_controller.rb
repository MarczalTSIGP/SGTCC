class SignaturesController < ApplicationController
  before_action :set_signature, only: :mark
  before_action :set_signature_code, only: :show
  before_action :can_show, only: :show

  def mark
    render json: Signature.mark(params[:orientation_id], params[:document_type_id])
  end

  def status
    render json: Signature.status_table(params[:orientation_id], params[:document_type_id])
  end

  def document; end

  def show
    @signature = @signature_code.signatures.first
  end

  private

  def set_signature_code
    @signature_code = SignatureCode.find_by(code: params[:code])
  end

  def can_show
    return if @signature_code.present? && @signature_code.all_signed?
    flash[:alert] = I18n.t('flash.documents.not_found')
    redirect_to signature_document_path
  end

  def set_signature
    @signature = Signature.find(params[:id])
  end
end
