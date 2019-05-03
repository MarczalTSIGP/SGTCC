class Professors::OrientationsController < Professors::BaseController
  before_action :set_orientation, only: [:show, :edit, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.orientations.index'),
                 :professors_orientations_path

  add_breadcrumb I18n.t('breadcrumbs.orientations.show'),
                 :professors_orientation_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.orientations.new'),
                 :new_professors_orientation_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.orientations.edit'),
                 :edit_professors_orientation_path,
                 only: [:edit]

  def index
    @orientations = Orientation.page(params[:page])
                               .search(params[:term])
                               .includes(:advisor, :academic, :calendar)
                               .order(created_at: :desc)
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

  def destroy
    @orientation.destroy
    feminine_success_destroy_message

    redirect_to professors_orientations_path
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
end
