class Professors::SupervisionsController < Professors::BaseController
  before_action :set_orientations
  before_action :set_orientation, only: :show
  before_action :set_index_breadcrumb, only: :show

  add_breadcrumb I18n.t('breadcrumbs.supervisions.index'),
                 :professors_supervisions_tcc_one_path,
                 only: [:tcc_one, :tcc_two]

  def tcc_one
    @title = calendar_title
    @search_url = professors_supervisions_search_tcc_one_path
    @orientations = paginate_orientations(@orientations.current_tcc_one)

    render :index
  end

  def tcc_two
    @title = calendar_title('two')
    @search_url = professors_supervisions_search_tcc_two_path
    @orientations = paginate_orientations(@orientations.current_tcc_two)

    render :index
  end

  def history
    @orientations = paginate_orientations(@orientations)
  end

  def show
    calendar = @orientation.calendar
    add_breadcrumb I18n.t("breadcrumbs.supervisions.tcc.#{calendar.tcc}.show",
                          calendar: calendar.year_with_semester),
                   professors_supervision_path(@orientation)
  end

  private

  def calendar_title(tcc = 'one')
    I18n.t("breadcrumbs.supervisions.tcc.#{tcc}.calendar",
           calendar: "#{Calendar.current_year}/#{Calendar.current_semester}")
  end

  def set_orientations
    @orientations = current_professor.supervisions.with_relationships.recent
  end

  def set_orientation
    @orientation = current_professor.supervisions.find(params[:id])
  end

  def paginate_orientations(data)
    Orientation.paginate_array(Orientation.search(params[:term], data), params[:page])
  end

  def set_index_breadcrumb
    calendar = @orientation.calendar
    calendar_title = I18n.t("breadcrumbs.supervisions.tcc.#{calendar.tcc}.calendar",
                            calendar: calendar.year_with_semester)
    @back_url = professors_supervisions_history_path
    if Calendar.current_calendar?(calendar)
      @back_url = current_tcc_index_link
      return add_breadcrumb calendar_title, @back_url
    end
    add_breadcrumb I18n.t('breadcrumbs.supervisions.history'), professors_supervisions_history_path
  end

  def current_tcc_index_link
    return professors_supervisions_tcc_one_path if @orientation.calendar.tcc == 'one'
    professors_supervisions_tcc_two_path
  end
end
