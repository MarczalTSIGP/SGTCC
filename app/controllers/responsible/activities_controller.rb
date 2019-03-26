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
    @activities = Activity.page(params[:page])
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
      redirect_to responsible_activities_path
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :new
    end
  end

  def update
    if @activity.update(activity_params)
      flash[:success] = I18n.t('flash.actions.update.m',
                               resource_name: Activity.model_name.human)
      redirect_to responsible_activity_path(@activity)
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :edit
    end
  end

  def destroy
    @activity.destroy

    flash[:success] = I18n.t('flash.actions.destroy.m',
                             resource_name: Activity.model_name.human)

    redirect_to responsible_activities_path
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:name, :activity_type_id)
  end
end
