class Academics::CalendarsController < Academics::BaseController
  def index
    calendars = current_academic.orientations
                                .includes(:calendar)
                                .order('calendars.year DESC, calendars.semester ASC')
                                .map(&:calendar)

    @calendars = Academic.paginate_array(calendars, params[:page])
  end

  private

  def set_calendar
    @calendar = Calendar.find(params[:id])
  end
end
