class Academics::ActivitiesController < Academics::BaseController
  before_action :set_calendar
  before_action :set_activity, only: [:show, :create, :update]
  before_action :set_index_breadcrumb
  before_action :set_academic_activity, only: [:show, :update]

  def index
    @activities = @calendar.activities.includes(:base_activity_type).recent
  end

  def show
    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.show"),
                   academics_calendar_activity_path(@calendar, @activity)
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

  def update
    if @academic_activity.update(academic_activity_params)
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

  def set_academic_activity
    @academic_activity = current_academic.academic_activities.find_by(activity_id: @activity.id)
    @academic_activity = AcademicActivity.new if @academic_activity.blank?
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
          .permit(:title, :summary, :pdf, :pdf_cache,
                  :academic_id, :activity_id, :complementary_files,
                  :complementary_files_cache)
  end
end
