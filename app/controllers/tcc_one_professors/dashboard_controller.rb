class TccOneProfessors::DashboardController < TccOneProfessors::BaseController
  before_action :set_documents, only: :index
  before_action :set_examination_boards, only: :index

  def index; end

  private

  def set_documents
    @documents = current_professor.documents_pending(params[:page]).per(5)
  end

  def set_examination_boards
    @examination_boards = ExaminationBoard.tcc_one
                                          .with_relationships
                                          .page(params[:page])
                                          .per(5)
                                          .order(created_at: :desc)
  end
end
