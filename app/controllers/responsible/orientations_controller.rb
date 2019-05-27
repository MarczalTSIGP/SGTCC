class Responsible::OrientationsController < Responsible::BaseController
  before_action :set_orientation, only: [:show, :edit, :update, :destroy]
  before_action :set_calendar, only: [:show, :edit]
  before_action :set_index_breadcrumb, only: [:show, :edit]

  add_breadcrumb I18n.t('breadcrumbs.orientations.index'),
                 :responsible_orientations_tcc_one_path,
                 only: [:tcc_one, :tcc_two, :new]

  add_breadcrumb I18n.t('breadcrumbs.orientations.new'),
                 :new_responsible_orientation_path,
                 only: [:new]

  def tcc_one
    @orientations = Orientation.by_tcc_one(params[:page], params[:term])
    @search_url = responsible_orientations_search_tcc_one_path

    render :index
  end

  def tcc_two
    @orientations = Orientation.by_tcc_two(params[:page], params[:term])
    @search_url = responsible_orientations_search_tcc_two_path

    render :index
  end

  def current_tcc_one(calendar = Calendar.current_by_tcc_one)
    add_breadcrumb orientation_title(calendar), responsible_orientations_current_tcc_one_path
    @orientations = Orientation.by_current_tcc_one(params[:page], params[:term])
    @search_url = responsible_orientations_search_current_tcc_one_path

    render :current_index
  end

  def current_tcc_two(calendar = Calendar.current_by_tcc_two)
    add_breadcrumb orientation_title(calendar), responsible_orientations_current_tcc_two_path
    @orientations = Orientation.by_current_tcc_two(params[:page], params[:term])
    @search_url = responsible_orientations_search_current_tcc_two_path

    render :current_index
  end

  def show
    add_breadcrumb I18n.t("breadcrumbs.orientations.tcc.#{@calendar.tcc}.show",
                          calendar: @calendar.year_with_semester),
                   responsible_orientation_path
  end

  def new
    @orientation = Orientation.new
  end

  def edit
    @title = I18n.t("breadcrumbs.orientations.tcc.#{@calendar.tcc}.edit",
                    calendar: @calendar.year_with_semester)
    add_breadcrumb @title, edit_responsible_orientation_path
  end

  def create
    @orientation = Orientation.new(orientation_params)

    if @orientation.save
      feminine_success_create_message
      redirect_to responsible_orientations_tcc_one_path
    else
      error_message
      render :new
    end
  end

  def update
    if @orientation.update(orientation_params)
      feminine_success_update_message
      redirect_to responsible_orientation_path(@orientation)
    else
      error_message
      render :edit
    end
  end

  def destroy
    @orientation.destroy
    feminine_success_destroy_message

    redirect_to responsible_orientations_tcc_one_path
  end

  private

  def set_orientation
    @orientation = Orientation.find(params[:id])
  end

  def set_calendar
    @calendar = @orientation.calendar
  end

  def orientation_params
    params.require(:orientation).permit(
      :title, :calendar_id, :academic_id,
      :advisor_id, :institution_id,
      professor_supervisor_ids: [],
      external_member_supervisor_ids: []
    )
  end

  def orientation_title(calendar)
    @title = I18n.t("breadcrumbs.orientations.tcc.#{calendar.tcc}.calendar",
                    calendar: calendar.year_with_semester)
  end

  def set_index_breadcrumb
    calendar_title = I18n.t("breadcrumbs.orientations.tcc.#{@calendar.tcc}.calendar",
                            calendar: @calendar.year_with_semester)
    current_calendar = (Calendar.current_by_tcc_one?(@calendar) ||
      Calendar.current_by_tcc_two?(@calendar))
    return add_breadcrumb calendar_title, current_tcc_index_link if current_calendar
    add_breadcrumb I18n.t('breadcrumbs.orientations.index'), responsible_orientations_tcc_one_path
  end

  def current_tcc_index_link
    return responsible_orientations_current_tcc_one_path if @calendar.tcc == 'one'
    responsible_orientations_current_tcc_two_path
  end
end
