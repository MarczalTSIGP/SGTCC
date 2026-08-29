class ExternalMembers::SupervisionsController < ExternalMembers::BaseController
  before_action :set_orientation, only: [:show, :document, :documents]
  before_action :set_current_calendar, only: [:show, :document, :documents]
  before_action :set_document_orientation_breadcrumb, only: [:documents, :document]
  before_action :set_tcc_one_title, only: :tcc_one
  before_action :set_tcc_two_title, only: :tcc_two

  add_breadcrumb I18n.t('breadcrumbs.supervisions.history'),
                 :external_members_supervisions_history_path,
                 only: [:history]

  def tcc_one
    load_orientations_by_tcc(:one)
    render :index
  end

  def tcc_two
    load_orientations_by_tcc(:two)
    render :index
  end

  def history
    @orientations = list_supervisions(:history)
  end

  def show
    add_index_breadcrumb
    add_breadcrumb show_supervision_calendar_title(@calendar),
                   external_members_supervision_path(@orientation)
  end

  def documents
    @documents = @orientation.documents.with_relationships.page(params[:page])
  end

  def document
    @document = @orientation.documents.find(params.expect(:document_id))
    @signatures = @document.mark
    @signature = @document.signature_by_user(current_external_member.id,
                                             current_external_member.user_types)

    add_breadcrumb I18n.t('breadcrumbs.documents.show'),
                   external_members_supervision_document_path(@orientation, @document)
  end

  private

  def set_orientation
    @orientation = current_external_member.supervisions.find(params.expect(:id))
  end

  def set_current_calendar
    @calendar = @orientation.current_calendar
  end

  def set_tcc_one_title
    @title = supervision_tcc_calendar_title
    add_breadcrumb supervision_calendar_title(Calendar.current_by_tcc_one),
                   external_members_supervisions_tcc_one_path
  end

  def set_tcc_two_title
    @title = supervision_tcc_calendar_title('two')
    add_breadcrumb supervision_calendar_title(Calendar.current_by_tcc_two),
                   external_members_supervisions_tcc_two_path
  end

  def load_orientations_by_tcc(tcc)
    @search_url = search_url_by_tcc(tcc)
    @orientations = list_supervisions(segment_by_tcc(tcc))
  end

  def list_supervisions(segment)
    Orientations::ParticipantListQuery.call(
      relation: current_external_member.supervisions,
      segment:,
      status: params[:status],
      term: params[:term],
      page: params[:page],
      profile: :external_member_supervision
    )
  end

  def search_url_by_tcc(tcc)
    {
      one: external_members_supervisions_search_tcc_one_path,
      two: external_members_supervisions_search_tcc_two_path
    }.fetch(tcc)
  end

  def segment_by_tcc(tcc)
    {
      one: :tcc_one,
      two: :tcc_two
    }.fetch(tcc)
  end

  def add_index_breadcrumb
    @back_url = external_members_supervisions_history_path
    if Calendar.current_calendar?(@calendar)
      @back_url = current_tcc_index_link
      return add_breadcrumb supervision_calendar_title(@calendar), @back_url
    end
    add_breadcrumb I18n.t('breadcrumbs.supervisions.history'),
                   external_members_supervisions_history_path
  end

  def current_tcc_index_link
    return external_members_supervisions_tcc_one_path if @calendar.tcc_one?

    external_members_supervisions_tcc_two_path
  end

  def set_document_orientation_breadcrumb
    add_breadcrumb supervision_calendar_title(@calendar), current_tcc_index_link
    add_breadcrumb I18n.t('breadcrumbs.documents.orientation'),
                   external_members_supervision_documents_path(@orientation)
  end
end
