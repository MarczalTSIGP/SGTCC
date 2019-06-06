class Professors::SupervisionsController < Professors::BaseController
  before_action :set_orientations
  before_action :set_orientation, only: :show

  add_breadcrumb I18n.t('breadcrumbs.supervisions.history'),
                 :professors_supervisions_history_path,
                 only: [:history]

  def tcc_one
    add_breadcrumb supervision_calendar_title(Calendar.current_by_tcc_one),
                   professors_supervisions_tcc_one_path
    @title = supervision_tcc_calendar_title
    @orientations = @orientations.current_tcc_one.search(params[:term]).page(params[:page])
    @search_url = professors_supervisions_search_tcc_one_path

    render :index
  end

  def tcc_two
    add_breadcrumb supervision_calendar_title(Calendar.current_by_tcc_two),
                   professors_supervisions_tcc_two_path
    @title = supervision_tcc_calendar_title('two')
    @orientations = @orientations.current_tcc_two.search(params[:term]).page(params[:page])
    @search_url = professors_supervisions_search_tcc_two_path

    render :index
  end

  def history
    @orientations = @orientations.search(params[:term]).page(params[:page])
  end

  def show
    add_index_breadcrumb
    add_breadcrumb show_supervision_calendar_title(@orientation.calendar),
                   professors_supervision_path(@orientation)
  end

  private

  def set_orientations
    @orientations = current_professor.supervisions.with_relationships.recent
  end

  def set_orientation
    @orientation = current_professor.supervisions.find(params[:id])
  end

  def add_index_breadcrumb
    calendar = @orientation.calendar
    @back_url = professors_supervisions_history_path
    if Calendar.current_calendar?(calendar)
      @back_url = current_tcc_index_link
      return add_breadcrumb supervision_calendar_title(calendar), @back_url
    end
    add_breadcrumb I18n.t('breadcrumbs.supervisions.history'), professors_supervisions_history_path
  end

  def current_tcc_index_link
    return professors_supervisions_tcc_one_path if @orientation.calendar.tcc == 'one'
    professors_supervisions_tcc_two_path
  end
end
