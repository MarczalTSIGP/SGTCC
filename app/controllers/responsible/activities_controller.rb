class Responsible::ActivitiesController < Responsible::BaseController
  before_action :set_calendar, except: [:index_by_calendar]
  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  def index
    index_url = responsible_calendar_activities_path
    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.index"), index_url

    @activities = @calendar.activities.includes(:base_activity_type).order(:final_date)
  end

  def show
    index_url = responsible_calendar_activities_path
    show_url = responsible_calendar_activity_path

    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.index"), index_url
    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.show"), show_url
  end

  def new
    index_url = responsible_calendar_activities_path
    new_url = new_responsible_calendar_activity_path

    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.index"), index_url
    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.new"), new_url

    @activity = @calendar.activities.new
  end

  def edit
    index_url = responsible_calendar_activities_path
    edit_url = edit_responsible_calendar_activity_path

    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.index"), index_url
    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.edit"), edit_url
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
          .permit(:name, :base_activity_type_id, :tcc,
                  :calendar_id, :initial_date, :final_date)
  end
end
