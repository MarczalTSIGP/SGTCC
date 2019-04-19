class Responsible::ActivitiesController < Responsible::BaseController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_action :set_calendar

  def index
    redirect_to action: 'tcc_one'
  end

  def tcc_one
    add_breadcrumb I18n.t('breadcrumbs.tcc.one.index'), activity_url

    @activities = Activity.by_tcc(tcc_one_enum, @calendar)
  end

  def tcc_two
    add_breadcrumb I18n.t('breadcrumbs.tcc.two.index'), activity_url

    @activities = Activity.by_tcc(tcc_two_enum, @calendar)
  end

  def tcc_one_update
    calendar_param = params[Activity.model_name.human]['calendar'] || nil
    calendar = Calendar.search_by_param(tcc_one_enum, calendar_param)

    if calendar.blank?
      calendar = Calendar.current_by_tcc(tcc_one_enum)
    end

    redirect_to responsible_calendar_activities_tcc_one_path(calendar)
  end

  def tcc_two_update
    calendar_param = params[Activity.model_name.human]['calendar'] || nil
    calendar = Calendar.search_by_param(tcc_two_enum, calendar_param)

    if calendar.blank?
      calendar = Calendar.current_by_tcc(Activity.tccs[:two])
    end

    redirect_to responsible_calendar_activities_tcc_two_path(calendar)
  end

  def show
    @back_url = activity_url

    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.index"), @back_url
    add_breadcrumb I18n.t('breadcrumbs.activities.show'), :responsible_calendar_activity_path
  end

  def new
    @back_url = activity_url

    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.index"), @back_url
    add_breadcrumb I18n.t('breadcrumbs.activities.new'), :new_responsible_calendar_activity_path

    @activity = Activity.new
  end

  def edit
    @back_url = activity_url

    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.index"), @back_url
    add_breadcrumb I18n.t('breadcrumbs.activities.edit'), :edit_responsible_calendar_activity_path
  end

  def create
    @activity = Activity.new(activity_params)

    if @activity.save
      flash[:success] = I18n.t('flash.actions.create.m',
                               resource_name: Activity.model_name.human)

      redirect_to activity_url(@activity.tcc)
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

    redirect_to activity_url
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def activity_params
    form_params = params.require(:activity)
                        .permit(:name, :base_activity_type_id, :tcc)

    form_params.merge(calendar_id: params[:calendar_id])
  end

  def tcc_one_enum
    Activity.tccs[:one]
  end

  def tcc_two_enum
    Activity.tccs[:two]
  end

  def activity_url(tcc = nil)
    tcc = @calendar.tcc if tcc.blank?
    return responsible_calendar_activities_tcc_one_path(@calendar) if tcc == 'one'
    responsible_calendar_activities_tcc_two_path(@calendar)
  end
end
