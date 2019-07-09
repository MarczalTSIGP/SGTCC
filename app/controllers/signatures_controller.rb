class SignaturesController < ApplicationController
  def mark
    render json: Signature.mark(params[:orientation_id], params[:document_type_id])
  end

  def status
    render json: Signature.status_table(params[:orientation_id], params[:document_type_id])
  end
end
