class ErrorsController < ApplicationController
  def show
    respond_to do |format|
      format.html { render status_code.to_s, status: status_code }
      format.any  { head status_code }
    end
  end

  protected

  def status_code
    params[:code] || 500
  end
end
