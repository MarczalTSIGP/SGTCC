class Responsible::DashboardController < Responsible::BaseController
  before_action :set_documents, only: :index

  def index; end

  def report
    dashboard = Dashboard::ResponsibleReport.new
    render json: dashboard.report
  end

  private

  def set_documents
    @documents = current_professor.documents_pending(params[:page]).per(5)
  end
end
