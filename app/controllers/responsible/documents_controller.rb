class Responsible::DocumentsController < Responsible::BaseController
  before_action :set_document, only: :judgment

  add_breadcrumb I18n.t('breadcrumbs.orientations.index'),
                 :responsible_orientations_tcc_one_path,
                 only: :orientation

  def judgment
    process_judgment
    render_turbo_stream_response
  end

  def process_judgment
    return handle_already_signed if @document.professor_signed?(current_professor)
    return handle_judgment_saved if @document.save_judgment(current_professor, judgment_params)

    handle_judgment_failed
  end

  def handle_already_signed
    flash.now[:sweet_error] = I18n.t('json.messages.documents.errors.update')
  end

  def handle_judgment_saved
    flash.now[:sweet_success] = I18n.t('json.messages.documents.success.update')
    @document.reload
  end

  def handle_judgment_failed
    flash.now[:sweet_error] = I18n.t('json.messages.empty_fields')
  end

  def render_turbo_stream_response
    render turbo_stream: [
      turbo_stream.replace(
        "document_review_#{@document.id}",
        partial: 'shared/documents/document_review',
        locals: document_review_locals
      ),
      turbo_stream.append('app', partial: 'shared/sweet_alert')
    ]
  end

  def document_review_locals
    {
      document: @document,
      has_permission: current_professor.role?('responsible'),
      can_edit: true
    }
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def judgment_params
    params.permit(:accept, :justification)
  end
end
