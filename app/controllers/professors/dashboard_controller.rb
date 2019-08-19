class Professors::DashboardController < Professors::BaseController
  before_action :set_meetings, only: :index
  before_action :set_documents, only: :index

  def index; end

  private

  def set_meetings
    @meetings = current_professor.meetings
                                 .with_relationship
                                 .page(params[:page])
                                 .per(5)
                                 .recent
  end

  def set_documents
    @documents = current_professor.documents_pending(params[:page]).per(5)
  end
end
