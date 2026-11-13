class Professors::MeetingsController < Professors::BaseController
  before_action :set_orientation, only: :orientation
  before_action :set_meeting, only: [:show, :edit, :update, :destroy]
  before_action :can_edit, only: [:edit, :update]
  before_action :can_destroy, only: :destroy

  add_breadcrumb I18n.t('breadcrumbs.meetings.index'),
                 :professors_meetings_path,
                 only: [:index, :show, :edit]

  add_breadcrumb I18n.t('breadcrumbs.meetings.new'),
                 :new_professors_meeting_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.meetings.edit'),
                 :edit_professors_meeting_path,
                 only: [:edit]

  def index
    @meetings = current_professor.meetings
                                 .with_relationship
                                 .page(params[:page])
                                 .order(date: :desc, created_at: :desc)
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.meetings.show'),
                   professors_meeting_path
  end

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
      render :new, status: :unprocessable_content
    end
  end

  def update
    @meeting.update(meeting_params) if meeting_params[:content].present?
    feminine_success_update_message
    redirect_to professors_meeting_path(@meeting)
  end

  def destroy
    @meeting.destroy
    feminine_success_destroy_message

    redirect_to professors_meetings_path
  end

  def orientation
    add_breadcrumb I18n.t('breadcrumbs.meetings.index'),
                   professors_orientation_meetings_path(@orientation)

    @meetings = @orientation.meetings
                            .page(params[:page])
                            .order(created_at: :desc)
    render :index
  end

  private

  def set_meeting
    @meeting = current_professor.meetings.find_by(id: params[:id])
    redirect_to professors_meetings_path if @meeting.blank?
  end

  def set_orientation
    @orientation = Orientation.find(params.expect(:id))
  end

  def meeting_params
    params.expect(meeting: [:date, :content, :orientation_id])
  end

  def meeting_policy
    MeetingPolicy.new(current_professor, @meeting)
  end

  def deny_meeting_change(action)
    flash[:alert] = I18n.t("flash.orientation.meeting.errors.#{action}")
    redirect_to professors_meetings_path
  end

  # `update` também passa por aqui: antes só `edit` era protegido, e um PATCH direto
  # alterava reunião já visualizada pelo acadêmico (corrigido após a REF-28).
  def can_edit
    deny_meeting_change('edit') unless meeting_policy.update?
  end

  def can_destroy
    deny_meeting_change('destroy') unless meeting_policy.destroy?
  end
end
