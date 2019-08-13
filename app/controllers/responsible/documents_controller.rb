class Responsible::DocumentsController < Responsible::BaseController
  before_action :set_document, only: [:judgment]

  def judgment
    render json: @document.save_judgment(current_professor, params)
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end
end
