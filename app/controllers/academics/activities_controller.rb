class Academics::ActivitiesController < Academics::BaseController
  before_action :set_calendar
  before_action :set_activity
  before_action :set_index_breadcrumb

  def index
    @activities = @calendar.activities.includes(:base_activity_type).recent
  end

  def show
    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.show"),
                   academics_calendar_activity_path(@calendar, @activity)
    @academic_activity = AcademicActivity.new
  end

  def create
    @academic_activity = AcademicActivity.new(academic_activity_params)

    if @academic_activity.save
      feminine_success_update_message
      redirect_to academics_calendar_activity_path(@calendar, @activity)
    else
      error_message
      render :show
    end
  end

  private

  def set_activity
    @activity = @calendar.activities.find(params[:id])
  end

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def set_index_breadcrumb
    add_breadcrumb I18n.t('breadcrumbs.calendars.index'), academics_calendars_path
    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.calendar",
                          calendar: @calendar.year_with_semester),
                   academics_calendar_activities_path(@calendar)
  end

  def academic_activity_params
    params.require(:academic_activity)
          .permit(:title, :summary, :pdf, :academic_id,
                  :activity_id, :complementary_files)
  end
end
