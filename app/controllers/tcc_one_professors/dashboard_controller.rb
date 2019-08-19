class TccOneProfessors::DashboardController < TccOneProfessors::BaseController
  before_action :set_documents, only: :index
  before_action :set_examination_boards, only: :index

  def index; end

  private

  def set_documents
    @documents = current_professor.documents_pending(params[:page]).per(5)
  end

  def set_examination_boards
    data = current_professor.examination_boards(params[:term])
    @examination_boards = Kaminari.paginate_array(data).page(params[:page]).per(5)
  end
end
