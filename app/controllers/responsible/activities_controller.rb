class Responsible::ActivitiesController < Responsible::BaseController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.activities.index'),
                 :responsible_activities_path

  add_breadcrumb I18n.t('breadcrumbs.activities.show'),
                 :responsible_activity_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.activities.new'),
                 :new_responsible_activity_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.activities.edit'),
                 :edit_responsible_activity_path,
                 only: [:edit]

  def index
    redirect_to action: 'tcc_one'
  end

  def tcc_one
    @title = I18n.t('breadcrumbs.tcc.one.index')
    current_calendar_id = Calendar.current_calendar_id_by_tcc

    @activities = Activity.where(tcc: Activity.tccs[:one], calendar_id: current_calendar_id)
                          .includes(:base_activity_type)
                          .order(:name)

    render :index
  end

  def tcc_two
    tcc_two = Activity.tccs[:two]
    @title = I18n.t('breadcrumbs.tcc.two.index')

    current_calendar_id = Calendar.current_calendar_id_by_tcc(tcc_two)

    @activities = Activity.where(tcc: tcc_two, calendar_id: current_calendar_id)
                          .includes(:base_activity_type)
                          .order(:name)

    render :index
  end

  def show; end

  def new
    @activity = Activity.new
  end

  def edit; end

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
                               resource_name: BaseActivity.model_name.human)
      redirect_to responsible_activity_path(@activity)
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :edit
    end
  end

  def destroy
    back_url = activity_url
    @activity.destroy

    flash[:success] = I18n.t('flash.actions.destroy.m',
                             resource_name: Activity.model_name.human)

    redirect_to back_url
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:name, :base_activity_type_id, :calendar_id, :tcc)
  end

  def activity_url
    return responsible_activities_tcc_one_path if @activity.tcc == 'one'
    responsible_activities_tcc_two_path
  end
end
