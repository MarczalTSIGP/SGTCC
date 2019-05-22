class Academics::CalendarsController < Academics::BaseController
  add_breadcrumb I18n.t('breadcrumbs.calendars.index'),
                 :academics_calendars_path

  def index
    calendars = current_academic.orientations
                                .includes(:calendar)
                                .order('calendars.year DESC, calendars.semester ASC')
                                .map(&:calendar)

    @calendars = Academic.paginate_array(calendars, params[:page])
  end
end
