class Responsible::DashboardController < Responsible::BaseController
  def index; end

  def report
    dashboard = Dashboard::ResponsibleReport.new
    render json: dashboard.report
  end
end
