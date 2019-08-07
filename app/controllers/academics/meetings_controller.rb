class Academics::MeetingsController < Academics::BaseController
  before_action :set_meeting, only: [:show, :update_viewed]

  add_breadcrumb I18n.t('breadcrumbs.meetings.index'),
                 :academics_meetings_path

  add_breadcrumb I18n.t('breadcrumbs.meetings.show'),
                 :academics_meeting_path,
                 only: [:show]

  def index
    @meetings = current_academic.meetings
                                .with_relationship
                                .page(params[:page])
                                .order(created_at: :desc)
  end

  def show; end

  def update_viewed
    render json: @meeting.update_viewed
  end

  private

  def set_meeting
    @meeting = current_academic.meetings.find_by(id: params[:id])
    redirect_to academics_meetings_path if @meeting.blank?
  end
end
