class Professors::RequestsController < Professors::BaseController
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

  def create
    @document = Document.new_tdo(current_professor, request_params)

    if @document.save
      feminine_success_create_message
      redirect_to professors_requests_path
    else
      render :new
    end
  end

  private

  def model_human
    I18n.t('flash.request.index')
  end

  def request_params
    params.require(:document).permit(:orientation_id, :justification)
  end
end
