class Responsible::ActivitiesController < Responsible::BaseController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_action :set_calendar_id

  add_breadcrumb I18n.t('breadcrumbs.activities.index'),
                 :responsible_calendar_activities_path

  add_breadcrumb I18n.t('breadcrumbs.activities.show'),
                 :responsible_calendar_activity_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.activities.new'),
                 :new_responsible_calendar_activity_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.activities.edit'),
                 :edit_responsible_calendar_activity_path,
                 only: [:edit]

  def index
    redirect_to action: 'tcc_one'
  end

  def tcc_one
    @title = I18n.t('breadcrumbs.tcc.one.index')
    @activities = Activity.by_tcc

    render :index
  end

  def tcc_two
    @title = I18n.t('breadcrumbs.tcc.two.index')
    @activities = Activity.by_tcc(Activity.tccs[:two])

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
                               resource_name: Activity.model_name.human)
      redirect_to responsible_calendar_activity_path(@calendar_id, @activity)
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

  def set_calendar_id
    @calendar_id = params[:calendar_id]
  end

  def activity_params
    form_params = params.require(:activity)
                        .permit(:name, :base_activity_type_id, :tcc)

    form_params.merge(calendar_id: @calendar_id)
  end

  def activity_url
    return responsible_calendar_activities_tcc_one_path(@calendar_id) if @activity.tcc == 'one'
    responsible_calendar_activities_tcc_two_path(@calendar_id)
  end
end
