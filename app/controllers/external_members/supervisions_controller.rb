class ExternalMembers::SupervisionsController < ExternalMembers::BaseController
  before_action :set_orientations
  before_action :set_orientation, only: [:show, :document, :documents]
  before_action :set_tcc_one_title, only: :tcc_one
  before_action :set_tcc_two_title, only: :tcc_two

  add_breadcrumb I18n.t('breadcrumbs.supervisions.history'),
                 :external_members_supervisions_history_path,
                 only: [:history]

  def tcc_one
    add_breadcrumb supervision_calendar_title(Calendar.current_by_tcc_one),
                   external_members_supervisions_tcc_one_path
    @orientations = search_and_paginate(@orientations.current_tcc_one(params[:status]))
    @search_url = external_members_supervisions_search_tcc_one_path

    render :index
  end

  def tcc_two
    add_breadcrumb supervision_calendar_title(Calendar.current_by_tcc_two),
                   external_members_supervisions_tcc_two_path
    @orientations = search_and_paginate(@orientations.current_tcc_two(params[:status]))
    @search_url = external_members_supervisions_search_tcc_two_path

    render :index
  end

  def history
    @orientations = search_and_paginate(@orientations)
  end

  def show
    add_index_breadcrumb
    add_breadcrumb show_supervision_calendar_title(@orientation.calendar),
                   external_members_supervision_path(@orientation)
  end

  def documents
    add_breadcrumb I18n.t('breadcrumbs.documents.orientation'),
                   external_members_supervision_documents_path(@orientation)

    @documents = @orientation.documents.with_relationships.page(params[:page])
  end

  def document
    @document = @orientation.documents.find(params[:document_id])

    add_breadcrumb I18n.t('breadcrumbs.documents.orientation'),
                   external_members_supervision_documents_path(@orientation)

    add_breadcrumb I18n.t('breadcrumbs.documents.show'),
                   external_members_supervision_document_path(@orientation, @document)
  end

  private

  def set_orientations
    status = params[:status]
    condition = status.present? ? { status: status } : {}
    @orientations = current_external_member.supervisions.where(condition).with_relationships.recent
  end

  def set_orientation
    @orientation = current_external_member.supervisions.find(params[:id])
  end

  def set_tcc_one_title
    @title = supervision_tcc_calendar_title
  end

  def set_tcc_two_title
    @title = supervision_tcc_calendar_title('two')
  end

  def search_and_paginate(data)
    data.search(params[:term]).page(params[:page])
  end

  def add_index_breadcrumb
    calendar = @orientation.calendar
    @back_url = external_members_supervisions_history_path
    if Calendar.current_calendar?(calendar)
      @back_url = current_tcc_index_link
      return add_breadcrumb supervision_calendar_title(calendar), @back_url
    end
    add_breadcrumb I18n.t('breadcrumbs.supervisions.history'),
                   external_members_supervisions_history_path
  end

  def current_tcc_index_link
    return external_members_supervisions_tcc_one_path if @orientation.calendar.tcc == 'one'
    external_members_supervisions_tcc_two_path
  end
end
