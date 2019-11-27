class Responsible::BaseActivitiesController < Responsible::BaseController
  before_action :set_base_activity, only: [:show, :edit, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.base_activities.index'),
                 :responsible_base_activities_tcc_one_path

  add_breadcrumb I18n.t('breadcrumbs.base_activities.show'),
                 :responsible_base_activity_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.base_activities.new'),
                 :new_responsible_base_activity_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.base_activities.edit'),
                 :edit_responsible_base_activity_path,
                 only: [:edit]

  def tcc_one
    @base_activities = BaseActivity.by_tcc_one(params[:term])
    @search_url = responsible_base_activities_search_tcc_one_path

    render :index
  end

  def tcc_two
    @base_activities = BaseActivity.by_tcc_two(params[:term])
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
      feminine_success_create_message
      redirect_to tcc_url
    else
      error_message
      render :new
    end
  end

  def update
    if @base_activity.update(activity_params)
      feminine_success_update_message
      redirect_to responsible_base_activity_path(@base_activity)
    else
      error_message
      render :edit
    end
  end

  def destroy
    back_url = tcc_url
    @base_activity.destroy

    feminine_success_destroy_message
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
