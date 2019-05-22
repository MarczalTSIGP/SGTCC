class TccOneProfessors::ActivitiesController < TccOneProfessors::BaseController
  before_action :set_calendar
  before_action :set_activity, only: [:show]
  before_action :set_index_breadcrumb

  def index
    @activities = @calendar.activities.includes(:base_activity_type).order(:final_date)
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.tcc.one.show'),
                   tcc_one_professors_calendar_activity_path(@calendar, @activity)
  end

  private

  def set_activity
    @activity = @calendar.activities.find(params[:id])
  end

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def set_index_breadcrumb
    add_breadcrumb I18n.t('breadcrumbs.calendars.index'),
                   tcc_one_professors_calendars_tcc_one_path
    add_breadcrumb I18n.t('breadcrumbs.tcc.one.calendar',
                          calendar: @calendar.year_with_semester),
                   tcc_one_professors_calendar_activities_path(@calendar)
  end
end
