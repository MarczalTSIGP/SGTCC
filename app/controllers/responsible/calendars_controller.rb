class Responsible::CalendarsController < Responsible::BaseController
  before_action :set_calendar, only: [:show, :edit, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.calendars.index'),
                 :responsible_calendars_path

  add_breadcrumb I18n.t('breadcrumbs.calendars.show'),
                 :responsible_calendar_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.calendars.new'),
                 :new_responsible_calendar_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.calendars.edit'),
                 :edit_responsible_calendar_path,
                 only: [:edit]

  def index
    @calendars = Calendar.page(params[:page]).search(params[:term]).order(year: :desc)
  end

  def show
    redirect_to responsible_calendar_activities_path(@calendar)
  end

  def new
    @calendar = Calendar.new
  end

  def edit; end

  def create
    @calendar = Calendar.new(calendar_params)

    if @calendar.save
      success_create_message
      redirect_to responsible_calendars_path
    else
      error_message
      render :new
    end
  end

  def update
    if @calendar.update(calendar_params)
      success_update_message
      redirect_to responsible_calendars_path
    else
      error_message
      render :edit
    end
  end

  def destroy
    if @calendar.destroy
      success_destroy_message
    else
      alert_destroy_bond_message
    end

    redirect_to responsible_calendars_path
  end

  private

  def set_calendar
    @calendar = Calendar.find(params[:id])
  end

  def calendar_params
    params.require(:calendar).permit(:tcc, :semester, :year)
  end
end
