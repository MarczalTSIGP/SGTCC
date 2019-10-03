class ExternalMembers::SupervisionActivitiesController < ExternalMembers::BaseController
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
    add_breadcrumb I18n.t('breadcrumbs.supervision_activities.show',
                          calendar: @calendar.year_with_semester),
                   external_members_supervision_activity_path(@orientation, @activity)
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
    @academic_activity = AcademicActivity.find_by(activity: @activity.id,
                                                  academic: @orientation.academic)
  end

  def set_breadcrumbs
    year_with_semester = @calendar.year_with_semester

    add_breadcrumb I18n.t('breadcrumbs.supervisions.index', calendar: year_with_semester),
                   external_members_supervisions_tcc_one_path

    add_breadcrumb I18n.t('breadcrumbs.supervision_activities.index', calendar: year_with_semester),
                   external_members_supervision_activities_path(@orientation)
  end
end
