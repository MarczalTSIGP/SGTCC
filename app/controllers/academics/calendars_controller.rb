class Academics::CalendarsController < Academics::BaseController
  add_breadcrumb I18n.t('breadcrumbs.calendars.index'),
                 :academics_calendars_path

  def index
    orientations = current_academic.orientations.with_relationships.recent
    @orientations = Academic.paginate_array(orientations, params[:page])
  end
end
