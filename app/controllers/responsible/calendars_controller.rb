class Responsible::CalendarsController < Responsible::BaseController
  before_action :set_calendar, only: [:show, :edit, :update, :destroy]
  before_action :set_resource_name, only: [:create, :update, :destroy]

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
    @calendars = Calendar.order(year: :desc)
  end

  def show; end

  def new
    @calendar = Calendar.new
  end

  def edit; end

  def create
    @calendar = Calendar.new(calendar_params)

    if @calendar.save
      flash[:success] = I18n.t('flash.actions.create.m', resource_name: @resource_name)
      redirect_to responsible_calendars_path
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :new
    end
  end

  def update
    if @calendar.update(calendar_params)
      flash[:success] = I18n.t('flash.actions.update.m', resource_name: @resource_name)
      redirect_to responsible_calendar_path(@calendar)
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :edit
    end
  end

  def destroy
    if @calendar.destroy
      flash[:success] = I18n.t('flash.actions.destroy.m', resource_name: @resource_name)
    else
      flash[:alert] = I18n.t('flash.actions.destroy.bond', resource_name: @resource_name)
    end

    redirect_to responsible_calendars_path
  end

  private

  def set_calendar
    @calendar = Calendar.find(params[:id])
  end

  def set_resource_name
    @resource_name = Calendar.model_name.human
  end

  def calendar_params
    params.require(:calendar).permit(:tcc, :semester, :year)
  end
end
