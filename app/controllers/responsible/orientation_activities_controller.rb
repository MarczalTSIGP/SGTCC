class Responsible::OrientationActivitiesController < Responsible::BaseController
  before_action :set_orientation
  before_action :set_calendar
  before_action :set_breadcrumbs

  def index
    # @activities = @orientation.current_calendar
    #                           .activities
    #                           .includes(:base_activity_type)
    #                           .page(params[:page])
    @activities = @calendar.activities
                           .includes(:base_activity_type)
  end

  def show
    @activity = @calendar.activities.find_by(id: params[:id])
    @academic_activity = @activity.academic_activity(@orientation)

    add_breadcrumb I18n.t('breadcrumbs.orientation_activities.show',
                          calendar: @calendar.year_with_semester),
                   responsible_orientation_calendar_activity_path(@orientation,
                                                                  @calendar,
                                                                  @activity)
  end

  private

  def set_orientation
    @orientation = Orientation.find(params[:orientation_id])
  end

  def set_calendar
    @calendar = @orientation.calendars.find(params[:calendar_id])
  end

  def set_breadcrumbs
    year_with_semester = @calendar.year_with_semester

    add_breadcrumb I18n.t('breadcrumbs.orientations.index', calendar: year_with_semester),
                   responsible_orientations_tcc_one_path

    add_breadcrumb I18n.t('breadcrumbs.orientation_activities.index', calendar: year_with_semester),
                   responsible_orientation_calendar_activities_path(@orientation, @calendar)
  end
end
