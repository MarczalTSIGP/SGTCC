class Professors::SupervisionsController < Professors::BaseController
  before_action :set_orientations
  before_action :set_orientation, only: [:show, :documents, :document]

  add_breadcrumb I18n.t('breadcrumbs.supervisions.history'),
                 :professors_supervisions_history_path,
                 only: [:history]

  def tcc_one
    add_breadcrumb supervision_calendar_title(Calendar.current_by_tcc_one),
                   professors_supervisions_tcc_one_path
    @title = supervision_tcc_calendar_title
    @orientations = search_and_paginate(@orientations.current_tcc_one(params[:status]))
    @search_url = professors_supervisions_search_tcc_one_path

    render :index
  end

  def tcc_two
    add_breadcrumb supervision_calendar_title(Calendar.current_by_tcc_two),
                   professors_supervisions_tcc_two_path
    @title = supervision_tcc_calendar_title('two')
    @orientations = search_and_paginate(@orientations.current_tcc_two(params[:status]))
    @search_url = professors_supervisions_search_tcc_two_path

    render :index
  end

  def history
    @orientations = search_and_paginate(@orientations)
  end

  def show
    add_index_breadcrumb
    add_breadcrumb show_supervision_calendar_title(@orientation.calendar),
                   professors_supervision_path(@orientation)
  end

  def documents
    add_breadcrumb I18n.t('breadcrumbs.documents.orientation'),
                   professors_supervision_documents_path(@orientation)

    @documents = @orientation.documents.with_relationships.page(params[:page])
  end

  def document
    @document = @orientation.documents.find(params[:document_id])

    add_breadcrumb I18n.t('breadcrumbs.documents.orientation'),
                   professors_supervision_documents_path(@orientation)

    add_breadcrumb I18n.t('breadcrumbs.documents.show'),
                   professors_supervision_document_path(@orientation, @document)
  end

  private

  def search_and_paginate(data)
    data.search(params[:term]).page(params[:page])
  end

  def set_orientations
    status = params[:status]
    condition = status.present? ? { status: status } : {}
    @orientations = current_professor.supervisions.where(condition).with_relationships.recent
  end

  def set_orientation
    @orientation = current_professor.supervisions.find(params[:id])
  end

  def add_index_breadcrumb
    calendar = @orientation.calendar
    @back_url = professors_supervisions_history_path
    if Calendar.current_calendar?(calendar)
      @back_url = current_tcc_index_link
      return add_breadcrumb supervision_calendar_title(calendar), @back_url
    end
    add_breadcrumb I18n.t('breadcrumbs.supervisions.history'), professors_supervisions_history_path
  end

  def current_tcc_index_link
    return professors_supervisions_tcc_one_path if @orientation.calendar.tcc == 'one'
    professors_supervisions_tcc_two_path
  end
end
