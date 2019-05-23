class Professors::SupervisionsController < Professors::BaseController
  before_action :set_tcc_one_title, only: :tcc_one
  before_action :set_tcc_two_title, only: :tcc_two
  before_action :set_supervisions

  add_breadcrumb I18n.t('breadcrumbs.supervisions.index'),
                 :professors_supervisions_tcc_one_path

  def tcc_one
    @search_url = professors_supervisions_search_tcc_one_path
    @orientations = paginate_orientations(@supervisions.tcc_one)

    render :index
  end

  def tcc_two
    @search_url = professors_supervisions_search_tcc_two_path
    @orientations = paginate_orientations(@supervisions.tcc_two)

    render :index
  end

  def history
    @orientations = paginate_orientations(@supervisions)
  end

  private

  def calendar_title(tcc = 'one')
    I18n.t("breadcrumbs.supervisions.tcc.#{tcc}.calendar",
           calendar: "#{Calendar.current_year}/#{Calendar.current_semester}")
  end

  def set_supervisions
    @supervisions = current_professor.supervisions.with_relationships.recent
  end

  def set_tcc_one_title
    @title = calendar_title
  end

  def set_tcc_two_title
    @title = calendar_title('two')
  end

  def paginate_orientations(data)
    Orientation.paginate_array(Orientation.search(params[:term], data), params[:page])
  end
end
