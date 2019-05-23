class Professors::SupervisionsController < Professors::BaseController
  before_action :set_tcc_one_title, only: :tcc_one
  before_action :set_tcc_two_title, only: :tcc_two

  add_breadcrumb I18n.t('breadcrumbs.supervisions.index'),
                 :professors_supervisions_tcc_one_path

  def tcc_one
    @search_url = professors_supervisions_search_tcc_one_path
    orientations = Orientation.search(params[:term], supervisions)
    @orientations = Orientation.paginate_array(orientations, params[:page])

    render :index
  end

  def tcc_two
    @search_url = professors_supervisions_search_tcc_one_path
    orientations = Orientation.search(params[:term], supervisions)
    @orientations = Orientation.paginate_array(orientations, params[:page])

    render :index
  end

  def history
    orientations = Orientation.search(params[:term], supervisions)
    @orientations = Orientation.paginate_array(orientations, params[:page])
  end

  private

  def supervisions
    current_professor.professor_supervisors.with_orientation.map(&:orientation)
  end

  def calendar_title(tcc = 'one')
    I18n.t("breadcrumbs.supervisions.tcc.#{tcc}.calendar",
           calendar: "#{Calendar.current_year}/#{Calendar.current_semester}")
  end

  def set_tcc_one_title
    @title = calendar_title
  end

  def set_tcc_two_title
    @title = calendar_title('two')
  end
end
