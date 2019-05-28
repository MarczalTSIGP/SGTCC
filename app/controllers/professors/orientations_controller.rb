class Professors::OrientationsController < Professors::BaseController
  before_action :set_orientation, only: [:show, :edit, :update]
  before_action :set_index_breadcrumb, only: [:show, :edit]

  add_breadcrumb I18n.t('breadcrumbs.orientations.index'),
                 :professors_orientations_tcc_one_path,
                 only: [:tcc_one]

  add_breadcrumb I18n.t('breadcrumbs.orientations.index'),
                 :professors_orientations_tcc_two_path,
                 only: [:tcc_two]

  add_breadcrumb I18n.t('breadcrumbs.orientations.history'),
                 :professors_orientations_history_path,
                 only: [:history]

  def index
    redirect_to action: :tcc_one
  end

  def tcc_one
    @title = I18n.t("breadcrumbs.orientations.tcc.#{Calendar.current_by_tcc_one&.tcc}.calendar",
                    calendar: Calendar.current_by_tcc_one&.year_with_semester)
    tcc_one_orientations = current_professor.orientations.current_tcc_one.with_relationships.recent
    @orientations = paginate_orientations(tcc_one_orientations)
    @search_url = professors_orientations_search_tcc_one_path

    render :index
  end

  def tcc_two
    @title = I18n.t("breadcrumbs.orientations.tcc.#{Calendar.current_by_tcc_two&.tcc}.calendar",
                    calendar: Calendar.current_by_tcc_two&.year_with_semester)
    tcc_two_orientations = current_professor.orientations.current_tcc_two.with_relationships.recent
    @orientations = paginate_orientations(tcc_two_orientations)
    @search_url = professors_orientations_search_tcc_two_path

    render :index
  end

  def history
    data = current_professor.orientations.with_relationships.recent
    orientations = Orientation.search(params[:term], data)
    @orientations = Orientation.paginate_array(orientations, params[:page])
  end

  def show
    title = I18n.t("breadcrumbs.orientations.tcc.#{@orientation.calendar.tcc}.show",
                   calendar: Calendar.current_by_tcc_one&.year_with_semester)
    add_breadcrumb title, professors_orientation_path
  end

  def new
    @title = I18n.t('breadcrumbs.orientations.tcc.one.new',
                    calendar: Calendar.current_by_tcc_one&.year_with_semester)
    add_breadcrumb @title, new_professors_orientation_path
    @orientation = Orientation.new
  end

  def edit
    @title = I18n.t("breadcrumbs.orientations.tcc.#{@orientation.calendar.tcc}.edit",
                    calendar: Calendar.current_by_tcc_one&.year_with_semester)
    add_breadcrumb @title, edit_professors_orientation_path
  end

  def create
    @orientation = Orientation.new(orientation_params)

    if @orientation.save
      feminine_success_create_message
      redirect_to professors_orientations_path
    else
      error_message
      render :new
    end
  end

  def update
    if @orientation.update(orientation_params)
      feminine_success_update_message
      redirect_to professors_orientation_path(@orientation)
    else
      error_message
      render :edit
    end
  end

  private

  def set_orientation
    @orientation = current_professor.orientations.find(params[:id])
  end

  def orientation_params
    params.require(:orientation).permit(
      :title, :calendar_id, :academic_id,
      :advisor_id, :institution_id,
      professor_supervisor_ids: [],
      external_member_supervisor_ids: []
    )
  end

  def paginate_orientations(data)
    orientations = Orientation.search(params[:term], data)
    @orientations = Orientation.paginate_array(orientations, params[:page])
  end

  def set_index_breadcrumb
    calendar = @orientation.calendar
    calendar_title = I18n.t("breadcrumbs.orientations.tcc.#{calendar.tcc}.calendar",
                            calendar: calendar.year_with_semester)
    @back_url = professors_orientations_history_path
    if Calendar.current_calendar?(calendar)
      @back_url = current_tcc_index_link
      return add_breadcrumb calendar_title, @back_url
    end
    add_breadcrumb I18n.t('breadcrumbs.orientations.history'), @back_url
  end

  def current_tcc_index_link
    return professors_orientations_tcc_one_path if @orientation.calendar.tcc == 'one'
    professors_orientations_tcc_two_path
  end
end
