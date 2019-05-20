class Professors::OrientationsController < Professors::BaseController
  before_action :set_calendar, only: [:by_calendar]
  before_action :set_orientation, only: [:show]
  before_action :set_title, only: [:current_tcc_one, :by_calendar]

  add_breadcrumb I18n.t('breadcrumbs.orientations.show'),
                 :professors_orientation_path,
                 only: [:show]

  def current_tcc_one
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

  def set_title
    calendar = Calendar.current_by_tcc_one
    calendar = @calendar if @calendar.present?
    @title = I18n.t('breadcrumbs.orientations.tcc.one.calendar_index',
                    calendar: calendar.year_with_semester)
  end
end
