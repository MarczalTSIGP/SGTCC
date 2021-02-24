class Academics::CalendarsController < Academics::BaseController
  add_breadcrumb I18n.t('breadcrumbs.calendars.index'),
                 :academics_calendars_path

  def index
    @orientations = current_academic.orientations.includes(:calendars,
                                                           :orientation_calendars,
                                                           :advisor,
                                                           :professor_supervisors,
                                                           :orientation_supervisors,
                                                           :external_member_supervisors)
    # @orientations = orientations.page(params[:page])
    # @calendars = current_academic.calendars.order year: :desc, semester: :desc
  end
end
