class Responsible::ReportsController < Responsible::BaseController
  def professors_total
    render json: Professor.count
  end

  def professors_available
    render json: Professor.where(available_advisor: true).count
  end

  def professors_unavailable
    render json: Professor.where(available_advisor: false).count
  end
end
