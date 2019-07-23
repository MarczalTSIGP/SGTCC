class Responsible::ReportsController < Responsible::BaseController
  def professors_total
    render json: Professor.count
  end

  def professors_available
    render json: Professor.available_advisor.count
  end

  def professors_unavailable
    render json: Professor.unavailable_advisor.count
  end
end
