class Responsible::ActivitiesTccTwoController < Responsible::BaseController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_action :set_calendar

  def index
    add_breadcrumb I18n.t('breadcrumbs.tcc.two.index'), activity_url

    @activities = Activity.by_tcc(Activity.tccs[:two], @calendar)
  end

  def show
    show_url = responsible_calendar_activities_tcc_two_path

    add_breadcrumb I18n.t('breadcrumbs.tcc.two.index'), activity_url
    add_breadcrumb I18n.t('breadcrumbs.activities.show'), show_url
  end

  def new
    new_url = new_responsible_calendar_activities_tcc_two_path

    add_breadcrumb I18n.t('breadcrumbs.tcc.two.index'), activity_url
    add_breadcrumb I18n.t('breadcrumbs.activities.new'), new_url

    @activity = Activity.new
  end

  def edit
    edit_url = edit_responsible_calendar_activities_tcc_two_path

    add_breadcrumb I18n.t('breadcrumbs.tcc.two.index'), activity_url
    add_breadcrumb I18n.t('breadcrumbs.activities.edit'), edit_url
  end

  def create
    @activity = Activity.new(activity_params)

    if @activity.save
      flash[:success] = I18n.t('flash.actions.create.m',
                               resource_name: Activity.model_name.human)

      redirect_to activity_url
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :new
    end
  end

  def update
    if @activity.update(activity_params)
      flash[:success] = I18n.t('flash.actions.update.m',
                               resource_name: Activity.model_name.human)

      redirect_to responsible_calendar_activities_tcc_two_path(@calendar, @activity)
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

  def index_by_calendar
    tcc_two = Activity.tccs[:two]
    calendar_param = params[:activity][:calendar] || nil
    calendar = Calendar.search_by_param(tcc_two, calendar_param)
    calendar = Calendar.current_by_tcc(tcc_two) if calendar.blank?

    redirect_to responsible_calendar_activities_tcc_two_index_path(calendar)
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

  def activity_url
    responsible_calendar_activities_tcc_two_index_path(@calendar)
  end
end
