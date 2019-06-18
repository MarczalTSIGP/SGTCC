class SignaturesController < ApplicationController
  before_action :set_signature, only: [:mark]

  def mark
    render json: @signature.orientation.signatures_mark
  end

  private

  def set_signature
    @signature = Signature.find(params[:id])
  end
end
