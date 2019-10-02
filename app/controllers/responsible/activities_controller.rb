class Responsible::ActivitiesController < Responsible::BaseController
  before_action :set_calendar, except: [:index_by_calendar]
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_action :set_index_breadcrumb, only: [:index, :show, :new, :edit]

  def index
    @activities = @calendar.activities.includes(:base_activity_type).recent
  end

  def show
    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.show"),
                   responsible_calendar_activity_path(@calendar, @activity)
  end

  def new
    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.new"),
                   new_responsible_calendar_activity_path

    @activity = @calendar.activities.new
  end

  def edit
    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.edit"),
                   edit_responsible_calendar_activity_path
  end

  def create
    @activity = @calendar.activities.new(activity_params)

    if @activity.save
      feminine_success_create_message
      redirect_to responsible_calendar_activities_path
    else
      error_message
      render :new
    end
  end

  def update
    if @activity.update(activity_params)
      feminine_success_update_message
      redirect_to responsible_calendar_activity_path(@calendar, @activity)
    else
      error_message
      render :edit
    end
  end

  def destroy
    @activity.destroy
    feminine_success_destroy_message

    redirect_to responsible_calendar_activities_path
  end

  def index_by_calendar
    redirect_to responsible_calendar_activities_path(params[:activity][:calendar])
  end

  private

  def set_activity
    @activity = @calendar.activities.find(params[:id])
  end

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def activity_params
    params.require(:activity)
          .permit(:name, :base_activity_type_id, :tcc, :judgment,
                  :calendar_id, :initial_date, :final_date)
  end

  def set_index_breadcrumb
    index_url = responsible_calendar_activities_path
    add_breadcrumb I18n.t('breadcrumbs.calendars.index'), responsible_calendars_tcc_one_path
    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.calendar",
                          calendar: @calendar.year_with_semester), index_url
  end
end
