class Professors::RequestsController < Professors::BaseController
  before_action :set_document, only: [:edit, :update]

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.index'),
                 :professors_requests_path

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.new'),
                 :new_professors_request_path,
                 only: :new

  def index
    @requests = current_professor.documents_request(params[:page])
  end

  def new
    @document = Document.new
  end

  def edit; end

  def create
    @document = Document.new_tdo(current_professor, request_params)

    if @document.save
      feminine_success_create_message
      redirect_to professors_document_path(@document)
    else
      render :new
    end
  end

  def update
    if @document.update_requester_justification(request_params)
      feminine_success_update_message
      redirect_to professors_document_path(@document)
    else
      render :edit
    end
  end

  private

  def set_document
    @document = current_professor.documents.find_by(id: params[:id])
  end

  def model_human
    I18n.t('flash.request.index')
  end

  def request_params
    params.require(:document).permit(:orientation_id, :justification)
  end
end
