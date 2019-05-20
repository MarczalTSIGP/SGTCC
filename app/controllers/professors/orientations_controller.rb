class Professors::OrientationsController < Professors::BaseController
  before_action :set_calendar
  before_action :set_orientation, only: [:show]
  before_action :set_title, only: [:by_calendar]
  before_action :set_index_breadcrumb

  def by_calendar
    data = @calendar.orientations.with_relationships.recent
    orientations = Orientation.search(params[:term], data)
    @orientations = Orientation.paginate_array(orientations, params[:page])

    render :index
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.orientations.show'),
                   professors_calendar_orientation_path(@calendar, @orientation)
  end

  private

  def set_orientation
    @orientation = @calendar.orientations.find(params[:id])
  end

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def set_title
    calendar = Calendar.current_by_tcc_one
    calendar = @calendar if @calendar.present?
    @title = I18n.t('breadcrumbs.orientations.tcc.one.calendar_index',
                    calendar: calendar.year_with_semester)
  end

  def set_index_breadcrumb
    add_breadcrumb I18n.t('breadcrumbs.orientations.index'),
                   professors_calendar_orientations_path(@calendar)
  end
end
