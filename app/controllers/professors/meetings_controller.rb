class Professors::MeetingsController < Professors::BaseController
  before_action :set_meeting, only: [:show, :edit, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.meetings.index'),
                 :professors_meetings_path

  add_breadcrumb I18n.t('breadcrumbs.meetings.show'),
                 :professors_meeting_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.meetings.new'),
                 :new_professors_meeting_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.meetings.edit'),
                 :edit_professors_meeting_path,
                 only: [:edit]

  def index
    @meetings = current_professor.meetings
                                 .search(params[:term])
                                 .page(params[:page])
                                 .order(created_at: :desc)
  end

  def show; end

  def new
    @meeting = Meeting.new
  end

  def edit; end

  def create
    @meeting = Meeting.new(meeting_params)

    if @meeting.save
      feminine_success_create_message
      redirect_to professors_meetings_path
    else
      error_message
      render :new
    end
  end

  def update
    if @meeting.update(meeting_params)
      feminine_success_update_message
      redirect_to professors_meeting_path(@meeting)
    else
      error_message
      render :edit
    end
  end

  def destroy
    @meeting.destroy
    feminine_success_destroy_message

    redirect_to professors_meetings_path
  end

  private

  def set_meeting
    @meeting = current_professor.meetings.find_by(id: params[:id])
    redirect_to professors_meetings_path if @meeting.blank?
  end

  def meeting_params
    params.require(:meeting).permit(:title, :content, :orientation_id)
  end
end
