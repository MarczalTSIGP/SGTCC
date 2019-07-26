class Responsible::DashboardController < Responsible::BaseController
  def index; end

  def report
    render json: {
      professors: {
        total: Professor.count,
        available: Professor.available_advisor.count,
        unavailable: Professor.unavailable_advisor.count
      }
    }
  end
end
