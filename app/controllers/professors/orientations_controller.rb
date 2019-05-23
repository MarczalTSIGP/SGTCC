class Professors::OrientationsController < Professors::BaseController
  before_action :set_orientation, only: [:show, :edit, :update]
  before_action :set_tcc_one_title, only: [:tcc_one]
  before_action :set_tcc_two_title, only: [:tcc_two]

  add_breadcrumb I18n.t('breadcrumbs.orientations.index'),
                 :professors_orientations_tcc_one_path,
                 only: [:tcc_one, :show, :new, :edit]

  add_breadcrumb I18n.t('breadcrumbs.orientations.index'),
                 :professors_orientations_tcc_two_path,
                 only: [:tcc_two]

  add_breadcrumb I18n.t('breadcrumbs.orientations.show'),
                 :professors_orientation_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.orientations.new'),
                 :new_professors_orientation_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.orientations.edit'),
                 :edit_professors_orientation_path,
                 only: [:edit]

  add_breadcrumb I18n.t('breadcrumbs.orientations.history'),
                 :professors_orientations_history_path,
                 only: [:history]

  def index
    redirect_to action: :tcc_one
  end

  def tcc_one
    tcc_one_orientations = current_professor.orientations.current_tcc_one.with_relationships.recent
    @orientations = paginate_orientations(tcc_one_orientations)
    @search_url = professors_orientations_search_tcc_one_path

    render :index
  end

  def tcc_two
    tcc_two_orientations = current_professor.orientations.current_tcc_two.with_relationships.recent
    @orientations = paginate_orientations(tcc_two_orientations)
    @search_url = professors_orientations_search_tcc_two_path

    render :index
  end

  def history
    data = current_professor.orientations.includes(:academic, :calendar).recent
    orientations = Orientation.search(params[:term], data)
    @orientations = Orientation.paginate_array(orientations, params[:page])
  end

  def show; end

  def new
    @orientation = Orientation.new
  end

  def edit; end

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
    @orientation = Orientation.find(params[:id])
  end

  def orientation_params
    params.require(:orientation).permit(
      :title, :calendar_id, :academic_id,
      :advisor_id, :institution_id,
      professor_supervisor_ids: [],
      external_member_supervisor_ids: []
    )
  end

  def title(calendar)
    @title = I18n.t("breadcrumbs.orientations.tcc.#{calendar&.tcc}.calendar",
                    calendar: calendar&.year_with_semester)
  end

  def set_tcc_one_title
    title(Calendar.current_by_tcc_one)
  end

  def set_tcc_two_title
    title(Calendar.current_by_tcc_two)
  end

  def paginate_orientations(data)
    orientations = Orientation.search(params[:term], data)
    @orientations = Orientation.paginate_array(orientations, params[:page])
  end
end
