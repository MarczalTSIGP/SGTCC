class Responsible::BaseActivitiesController < Responsible::BaseController
  before_action :set_base_activity, only: [:show, :edit, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.base_activities.index'),
                 :responsible_base_activities_path

  add_breadcrumb I18n.t('breadcrumbs.base_activities.show'),
                 :responsible_base_activity_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.base_activities.new'),
                 :new_responsible_base_activity_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.base_activities.edit'),
                 :edit_responsible_base_activity_path,
                 only: [:edit]

  def index
    redirect_to action: 'tcc_one'
  end

  def tcc_one
    @base_activities = BaseActivity.get_by_tcc('TCC 1', params[:term])
    @search_url = responsible_base_activities_search_tcc_one_path

    render :index
  end

  def tcc_two
    @base_activities = BaseActivity.get_by_tcc('TCC 2', params[:term])
    @search_url = responsible_base_activities_search_tcc_two_path

    render :index
  end

  def show; end

  def new
    @base_activity = BaseActivity.new
  end

  def edit; end

  def create
    @base_activity = BaseActivity.new(activity_params)

    if @base_activity.save
      flash[:success] = I18n.t('flash.actions.create.m',
                               resource_name: BaseActivity.model_name.human)

      redirect_to tcc_url
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :new
    end
  end

  def update
    if @base_activity.update(activity_params)
      flash[:success] = I18n.t('flash.actions.update.m',
                               resource_name: BaseActivity.model_name.human)
      redirect_to responsible_base_activity_path(@base_activity)
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :edit
    end
  end

  def destroy
    back_url = tcc_url
    @base_activity.destroy

    flash[:success] = I18n.t('flash.actions.destroy.m',
                             resource_name: BaseActivity.model_name.human)

    redirect_to back_url
  end

  private

  def set_base_activity
    @base_activity = BaseActivity.find(params[:id])
  end

  def activity_params
    params.require(:base_activity).permit(:name, :base_activity_type_id, :tcc)
  end

  def tcc_url
    return responsible_base_activities_tcc_one_path if @base_activity.tcc == 'one'
    responsible_base_activities_tcc_two_path
  end
end
