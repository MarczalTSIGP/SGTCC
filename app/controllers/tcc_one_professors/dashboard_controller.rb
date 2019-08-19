class TccOneProfessors::DashboardController < TccOneProfessors::BaseController
  before_action :set_documents, only: :index

  def index; end

  private

  def set_documents
    @documents = current_professor.documents_pending(params[:page]).per(5)
  end
end
