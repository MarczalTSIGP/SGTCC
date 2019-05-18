class Academics::ActivitiesController < Academics::BaseController
  before_action :set_calendar
  before_action :set_activity, only: [:show]

  def index
    index_url = academics_calendar_activities_path
    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.index"), index_url

    @activities = @calendar.activities.includes(:base_activity_type).order(:final_date)
  end

  def show
    index_url = academics_calendar_activities_path
    show_url = academics_calendar_activity_path

    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.index"), index_url
    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.show"), show_url
  end

  private

  def set_activity
    @activity = @calendar.activities.find(params[:id])
  end

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end
end
