class Responsible::ActivitiesController < Responsible::BaseController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_action :set_calendar, except: [:index_by_calendar]

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
      flash[:success] = I18n.t('flash.actions.create.m',
                               resource_name: Activity.model_name.human)

      redirect_to responsible_calendar_activities_path
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :new
    end
  end

  def update
    if @activity.update(activity_params)
      flash[:success] = I18n.t('flash.actions.update.m',
                               resource_name: Activity.model_name.human)

      redirect_to responsible_calendar_activity_path(@calendar, @activity)
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :edit
    end
  end

  def destroy
    @activity.destroy

    flash[:success] = I18n.t('flash.actions.destroy.m',
                             resource_name: Activity.model_name.human)

    redirect_to responsible_calendar_activities_path
  end

  def index_by_calendar
    calendar_id = params[:activity][:calendar]

    redirect_to responsible_calendar_activities_path(calendar_id)
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def activity_params
    params.require(:activity)
          .permit(:name, :base_activity_type_id, :tcc, :calendar_id, :initial_date, :final_date)
  end
end
