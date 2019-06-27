class SignaturesController < ApplicationController
  before_action :set_signature, only: :mark
  before_action :set_orientation, only: :status

  def mark
    render json: @signature.orientation.signatures_mark
  end

  def status
    render json: @orientation.signatures_status
  end

  private

  def set_signature
    @signature = Signature.find(params[:id])
  end

  def set_orientation
    @orientation = Orientation.find(params[:orientation_id])
  end
end
