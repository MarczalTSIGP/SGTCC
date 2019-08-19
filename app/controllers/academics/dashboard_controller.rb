class Academics::DashboardController < Academics::BaseController
  before_action :set_meetings, only: :index
  before_action :set_documents, only: :index
  before_action :set_examination_boards, only: :index

  def index; end

  private

  def set_meetings
    @meetings = current_academic.meetings
                                .with_relationship
                                .page(params[:page])
                                .per(5)
                                .recent
  end

  def set_documents
    @documents = current_academic.documents_pending(params[:page]).per(5)
  end

  def set_examination_boards
    @examination_boards = current_academic.examination_boards
                                          .page(params[:page])
                                          .per(5)
                                          .order(:tcc, created_at: :desc)
                                          .with_relationships
  end
end
