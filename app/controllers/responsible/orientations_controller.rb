class Responsible::OrientationsController < Responsible::BaseController
  before_action :set_orientation, only: [:show, :edit, :update, :destroy]
  before_action :set_tcc_one_title, only: :current_tcc_one
  before_action :set_tcc_two_title, only: :current_tcc_two

  add_breadcrumb I18n.t('breadcrumbs.orientations.index'),
                 :responsible_orientations_path

  add_breadcrumb I18n.t('breadcrumbs.orientations.show'),
                 :responsible_orientation_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.orientations.new'),
                 :new_responsible_orientation_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.orientations.edit'),
                 :edit_responsible_orientation_path,
                 only: [:edit]

  def index
    redirect_to action: :tcc_one
  end

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

  def current_tcc_one
    @orientations = Orientation.by_current_tcc_one(params[:page], params[:term])
    @search_url = responsible_orientations_search_current_tcc_one_path

    render :current_index
  end

  def current_tcc_two
    @orientations = Orientation.by_current_tcc_two(params[:page], params[:term])
    @search_url = responsible_orientations_search_current_tcc_two_path

    render :current_index
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
      redirect_to responsible_orientations_path
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

    redirect_to responsible_orientations_path
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
    @title = I18n.t("breadcrumbs.orientations.tcc.#{calendar.tcc}.calendar",
                    calendar: calendar.year_with_semester)
  end

  def set_tcc_one_title
    title(Calendar.current_by_tcc_one)
  end

  def set_tcc_two_title
    title(Calendar.current_by_tcc_two)
  end
end
