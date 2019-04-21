class Responsible::ActivitiesTccTwoController < Responsible::ActivitiesController
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
    calendar = Calendar.find(params[:activity][:calendar])

    redirect_to responsible_calendar_activities_tcc_two_index_path(calendar)
  end

  private

  def activity_url
    responsible_calendar_activities_tcc_two_index_path(@calendar)
  end
end
