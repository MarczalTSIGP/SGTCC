class ExternalMembers::ActivitiesController < ExternalMembers::BaseController
  before_action :set_calendar
  before_action :set_activity, only: :show

  def index
    add_calendar_index_breadcrumb
    add_activities_index_breadcrumb
    @activities = @calendar.activities.includes(:base_activity_type).recent
  end

  def show
    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.show"),
                   external_members_calendar_activity_path(@calendar, @activity)
  end

  private

  def set_activity
    @activity = @calendar.activities.find(params[:id])
  end

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def add_activities_index_breadcrumb
    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.calendar",
                          calendar: @calendar.year_with_semester),
                   external_members_calendar_activities_path(@calendar)
  end

  def add_calendar_index_breadcrumb
    add_breadcrumb I18n.t('breadcrumbs.calendars.index'), external_members_calendars_path
  end
end
