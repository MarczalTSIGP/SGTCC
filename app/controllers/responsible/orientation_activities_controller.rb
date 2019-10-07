class Responsible::OrientationActivitiesController < Responsible::BaseController
  before_action :set_orientation
  before_action :set_calendar
  before_action :set_activity, only: :show
  before_action :set_academic_activity, only: :show
  before_action :set_breadcrumbs

  def index
    @activities = @orientation.calendar
                              .activities
                              .includes(:base_activity_type)
                              .page(params[:page])
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.orientation_activities.show',
                          calendar: @calendar.year_with_semester),
                   responsible_orientation_activity_path(@orientation, @activity)
  end

  private

  def set_orientation
    @orientation = Orientation.find(params[:id])
  end

  def set_calendar
    @calendar = @orientation.calendar
  end

  def set_activity
    @activity = @calendar.activities.find_by(id: params[:activity_id])
  end

  def set_academic_activity
    @academic_activity = @activity.academic_activity(@orientation)
  end

  def set_breadcrumbs
    year_with_semester = @calendar.year_with_semester

    add_breadcrumb I18n.t('breadcrumbs.orientations.index', calendar: year_with_semester),
                   responsible_orientations_tcc_one_path

    add_breadcrumb I18n.t('breadcrumbs.orientation_activities.index', calendar: year_with_semester),
                   responsible_orientation_activities_path(@orientation)
  end
end
