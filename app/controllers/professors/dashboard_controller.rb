class Professors::DashboardController < Professors::BaseController
  before_action :set_meetings, only: :index
  before_action :set_activities, only: :index
  before_action :set_documents, only: :index
  before_action :set_examination_boards, only: :index
  before_action :set_professor, only: :report

  def index; end

  def report
    dashboard = Dashboard::ProfessorReport.new(current_professor, @professor)
    render json: dashboard.report
  end

  private

  def set_meetings
    @meetings = current_professor.meetings
                                 .not_viewed
                                 .with_relationship
                                 .page(params[:page])
                                 .per(5)
                                 .recent
  end

  def set_activities
    @activities = current_professor.activities_to_be_approved
  end

  def set_documents
    @documents = current_professor.documents_pending(params[:page]).per(5)
  end

  def set_examination_boards
    data = current_professor.examination_boards(params[:term])
    @examination_boards = Kaminari.paginate_array(data).page(params[:page]).per(6)
  end

  def set_professor
    @professor = Professor.find(params[:professor_id])
  end
end
