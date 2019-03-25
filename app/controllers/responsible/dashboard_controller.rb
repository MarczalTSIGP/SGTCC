class Responsible::DashboardController < Responsible::BaseController
  def index
    authorize(Professor)
  end
end
