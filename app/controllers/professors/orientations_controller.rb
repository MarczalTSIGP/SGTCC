class Professors::OrientationsController < Professors::BaseController
  before_action :set_calendar, only: [:by_calendar]
  before_action :set_orientation, only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.orientations.show'),
                 :professors_orientation_path,
                 only: [:show]

  def current_tcc_one
    calendar = Calendar.current_by_tcc_one.year_with_semester
    @title = I18n.t('breadcrumbs.orientations.tcc.one.index', calendar: calendar)
    @orientations = Orientation.by_current_tcc_one(params[:page], params[:term])
    @search_url = professors_orientations_search_current_tcc_one_path

    render :current_index
  end

  def by_calendar
    orientations = @calendar.orientations.with_relationships.recent
    @orientations = Orientation.paginate_array(orientations, params[:page])

    render :index
  end

  def show; end

  private

  def set_orientation
    @orientation = Orientation.find(params[:id])
  end

  def set_calendar
    @calendar = Calendar.find(params[:id])
  end
end
