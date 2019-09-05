class Responsible::ProfessorsController < Responsible::BaseController
  before_action :set_professor, only: [:show, :edit, :update, :destroy, :tcc_one, :tcc_two]

  add_breadcrumb I18n.t('breadcrumbs.professors.index'),
                 :responsible_professors_path

  add_breadcrumb I18n.t('breadcrumbs.professors.new'),
                 :new_responsible_professor_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.professors.show'),
                 :responsible_professor_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.professors.edit'),
                 :edit_responsible_professor_path,
                 only: [:edit]

  def index
    @professors = paginate(Professor.all)
    @search_url = responsible_professors_search_path
  end

  def available
    @professors = paginate(Professor.available_advisor)
    @search_url = responsible_professors_available_search_path
    render :index
  end

  def unavailable
    @professors = paginate(Professor.unavailable_advisor)
    @search_url = responsible_professors_unavailable_search_path
    render :index
  end

  def show; end

  def new
    @professor = Professor.new
  end

  def edit; end

  def create
    @professor = Professor.new(professor_params)
    @professor.define_singleton_method(:password_required?) { false }

    if @professor.save
      success_create_message
      redirect_to responsible_professors_path
    else
      error_message
      render :new
    end
  end

  def update
    if @professor.update(professor_params)
      success_update_message
      redirect_to responsible_professor_path
    else
      error_message
      render :edit
    end
  end

  def destroy
    if @professor.destroy
      success_destroy_message
    else
      alert_destroy_bond_message
    end

    redirect_to responsible_professors_url
  end

  def tcc_one
    @orientations = @professor.orientations.by_tcc_one(
      params[:page], params[:term], params[:status]
    )

    @search_url = responsible_professor_orientations_search_tcc_one_path(@professor)

    render 'responsible/orientations/index'
  end

  def tcc_two
    @orientations = @professor.orientations.by_tcc_two(
      params[:page], params[:term], params[:status]
    )

    @search_url = responsible_professor_orientations_search_tcc_two_path(@professor)

    render 'responsible/orientations/index'
  end

  private

  def paginate(data)
    data.page(params[:page]).search(params[:term]).order(:name)
  end

  def set_professor
    @professor = Professor.find(params[:id])
  end

  def professor_params
    params.require(:professor).permit(
      :name, :email,
      :username, :lattes,
      :gender, :is_active,
      :working_area, :available_advisor,
      :professor_type_id, :scholarity_id,
      role_ids: []
    )
  end
end
