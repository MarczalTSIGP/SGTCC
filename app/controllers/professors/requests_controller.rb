class Professors::RequestsController < Professors::BaseController
  before_action :set_orientation, only: :create

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.index'),
                 :professors_requests_path

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.new'),
                 :new_professors_request_path,
                 only: :new

  def index
    @requests = current_professor.signatures_for_review(params[:page])
  end

  def new
    @document = Document.new
  end

  def create
    justification = request_params[:justification]
    document = Document.create_tdo(current_professor, justification, @orientation)
    feminine_success_create_message if document
    redirect_to professors_requests_path
  end

  private

  def model_human
    I18n.t('flash.request.index')
  end

  def set_orientation
    @orientation = Orientation.find(request_params[:orientation])
  end

  def request_params
    params.require(:document).permit(:orientation, :justification)
  end
end
