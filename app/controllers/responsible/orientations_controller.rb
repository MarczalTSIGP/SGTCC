class Responsible::OrientationsController < Responsible::BaseController
  before_action :set_orientation, only: [:show, :edit, :update, :destroy, :renew]
  before_action :set_calendar, only: [:show, :edit]
  before_action :set_justification, only: [:renew]

  add_breadcrumb I18n.t('breadcrumbs.orientations.index'),
                 :responsible_orientations_tcc_one_path,
                 only: [:tcc_one, :new]

  add_breadcrumb I18n.t('breadcrumbs.orientations.index'),
                 :responsible_orientations_tcc_two_path,
                 only: [:tcc_two]

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
    @title = orientation_calendar_title(calendar)
    add_breadcrumb @title, responsible_orientations_current_tcc_one_path
    @orientations = Orientation.by_current_tcc_one(params[:page], params[:term])
    @search_url = responsible_orientations_search_current_tcc_one_path

    render :current_index
  end

  def current_tcc_two(calendar = Calendar.current_by_tcc_two)
    @title = orientation_calendar_title(calendar)
    add_breadcrumb @title, responsible_orientations_current_tcc_two_path
    @orientations = Orientation.by_current_tcc_two(params[:page], params[:term])
    @search_url = responsible_orientations_search_current_tcc_two_path

    render :current_index
  end

  def show
    add_index_breadcrumb
    add_breadcrumb show_orientation_calendar_title, responsible_orientation_path
  end

  def new
    @orientation = Orientation.new
  end

  def edit
    add_index_breadcrumb
    @title = edit_orientation_calendar_title
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

  def renew
    if @next_calendar.blank?
      msg = I18n.t('activerecord.errors.models.orientation.attributes.calendar.empty_next_semester')
      render json: { message: msg, status: :not_found }
    elsif @orientation.status == 'IN_PROGRESS'
      new_orientation = @orientation.renew(@justification, @next_calendar)
      render json: {
        message: I18n.t('json.messages.orientation.renew.save'),
        orientation: { status: Orientation.statuses[new_orientation.status] }
      }
    end
  end

  private

  def set_orientation
    @orientation = Orientation.find(params[:id])
  end

  def set_calendar
    @calendar = @orientation.calendar
  end

  def set_justification
    @justification = params['orientation']['renewal_justification']
    @next_calendar = Calendar.next_semester(@orientation.calendar)
  end

  def orientation_params
    params.require(:orientation).permit(
      :title, :calendar_id, :academic_id,
      :advisor_id, :institution_id,
      professor_supervisor_ids: [],
      external_member_supervisor_ids: []
    )
  end

  def add_index_breadcrumb
    @back_url = responsible_orientations_tcc_one_path
    if Calendar.current_calendar?(@calendar)
      @back_url = current_tcc_index_path
      return orientation_calendar_title, @back_url
    end
    add_breadcrumb I18n.t('breadcrumbs.orientations.index'), @back_url
  end

  def current_tcc_index_path
    return responsible_orientations_current_tcc_one_path if @calendar.tcc == 'one'
    responsible_orientations_current_tcc_two_path
  end
end
