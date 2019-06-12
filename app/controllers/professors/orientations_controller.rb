class Professors::OrientationsController < Professors::BaseController
  before_action :set_orientation, only: [:show, :edit, :update]
  before_action :set_orientations, only: [:tcc_one, :tcc_two, :history]
  before_action :set_tcc_one_title, only: :tcc_one
  before_action :set_tcc_two_title, only: :tcc_two

  add_breadcrumb I18n.t('breadcrumbs.orientations.index'),
                 :professors_orientations_tcc_one_path,
                 only: [:tcc_one]

  add_breadcrumb I18n.t('breadcrumbs.orientations.index'),
                 :professors_orientations_tcc_two_path,
                 only: [:tcc_two]

  def tcc_one
    @orientations = search_and_paginate(@orientations.current_tcc_one(params[:status]))
    @search_url = professors_orientations_search_tcc_one_path

    render :index
  end

  def tcc_two
    @orientations = search_and_paginate(@orientations.current_tcc_two(params[:status]))
    @search_url = professors_orientations_search_tcc_two_path

    render :index
  end

  def history
    add_breadcrumb I18n.t('breadcrumbs.orientations.history'), professors_orientations_history_path
    @orientations = search_and_paginate(@orientations)
  end

  def show
    add_index_breadcrumb
    calendar = Calendar.current_by_tcc_one
    add_breadcrumb show_orientation_calendar_title(calendar), professors_orientation_path
  end

  def new
    @title = I18n.t('breadcrumbs.orientations.tcc.one.new',
                    calendar: Calendar.current_by_tcc_one&.year_with_semester)
    add_breadcrumb @title, new_professors_orientation_path
    @orientation = Orientation.new
  end

  def edit
    add_index_breadcrumb
    @title = edit_orientation_calendar_title(@orientation.calendar)
    add_breadcrumb @title, edit_professors_orientation_path
  end

  def create
    @orientation = Orientation.new(orientation_params)

    if @orientation.save
      feminine_success_create_message
      redirect_to professors_orientations_tcc_one_path
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

  def set_orientations
    status = params[:status]
    condition = status.present? ? { status: status } : {}
    @orientations = current_professor.orientations.where(condition)
  end

  def set_tcc_one_title
    @title = orientation_calendar_title(Calendar.current_by_tcc_one)
  end

  def set_tcc_two_title
    @title = orientation_calendar_title(Calendar.current_by_tcc_two)
  end

  def search_and_paginate(data)
    data.with_relationships.recent.search(params[:term]).page(params[:page])
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
    calendar = @orientation.calendar
    @back_url = professors_orientations_history_path
    if Calendar.current_calendar?(calendar)
      @back_url = current_tcc_index_link
      return add_breadcrumb orientation_calendar_title(calendar), @back_url
    end
    add_breadcrumb I18n.t('breadcrumbs.orientations.history'), @back_url
  end

  def current_tcc_index_link
    return professors_orientations_tcc_one_path if @orientation.calendar.tcc == 'one'
    professors_orientations_tcc_two_path
  end
end
