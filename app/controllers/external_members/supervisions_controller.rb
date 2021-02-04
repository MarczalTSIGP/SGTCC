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
    @orientations = current_external_member.supervisions
    @orientations = @orientations.where(status: params[:status]) if params[:status]
    @orientations = @orientations.search(params[:term]).page(params[:page])
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
    @document = @orientation.documents.find(params[:document_id])
    add_breadcrumb I18n.t('breadcrumbs.documents.show'),
                   external_members_supervision_document_path(@orientation, @document)
  end

  private

  def set_orientation
    @orientation = current_external_member.supervisions.find(params[:id])
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
    @search_url = send("external_members_supervisions_search_tcc_#{tcc}_path")
    @orientations = current_external_member.supervisions
                                           .send("current_tcc_#{tcc}", params[:status])
                                           .search(params[:term]).page(params[:page])
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
    return external_members_supervisions_tcc_one_path if @calendar.tcc == 'one'

    external_members_supervisions_tcc_two_path
  end

  def set_document_orientation_breadcrumb
    add_breadcrumb supervision_calendar_title(@calendar), current_tcc_index_link
    add_breadcrumb I18n.t('breadcrumbs.documents.orientation'),
                   external_members_supervision_documents_path(@orientation)
  end
end
