class Responsible::DocumentsController < Responsible::BaseController
  before_action :set_document, only: :judgment

  add_breadcrumb I18n.t('breadcrumbs.orientations.index'),
                 :responsible_orientations_tcc_one_path,
                 only: :orientation

  def judgment
    if @document.professor_signed?(current_professor)
      flash.now[:sweet_error] = I18n.t('json.messages.documents.errors.update')
    elsif @document.save_judgment(current_professor, judgment_params)
      flash.now[:sweet_success] = I18n.t('json.messages.documents.success.update')
      @document.reload
    else
      flash.now[:sweet_error] = I18n.t('json.messages.empty_fields')
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "document_review_#{@document.id}",
            partial: 'shared/documents/document_review',
            locals: { 
              document: @document,
              has_permission: current_professor.role?('responsible'),
              can_edit: true
            }
          ),
          turbo_stream.append('app', partial: 'shared/sweet_alert')
        ]
      end
      format.html { redirect_back(fallback_location: responsible_root_path) }
    end
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def judgment_params
    params.permit(:accept, :justification)
  end
end
