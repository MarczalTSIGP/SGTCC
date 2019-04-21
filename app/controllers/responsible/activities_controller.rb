class Responsible::ActivitiesController < Responsible::BaseController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_action :set_calendar

  protected

  def show; end

  def edit; end

  def update; end

  def destroy; end

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
end
