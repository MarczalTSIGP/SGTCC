class Responsible::DocumentsController < Responsible::BaseController
  before_action :set_document, only: :judgment

  add_breadcrumb I18n.t('breadcrumbs.orientations.index'),
                 :responsible_orientations_tcc_one_path,
                 only: :orientation

  def judgment
    if @document.professor_signed?(current_professor)
      render json: { status: false,
                     message: I18n.t('json.messages.documents.errors.update') }
    else
      render json: { status: @document.save_judgment(current_professor, params),
                     message: I18n.t('json.messages.documents.success.update') }
    end
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end
end
