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
    document = Document.create_tdo_request(@orientation, current_professor,
                                           request_params[:justification])

    if document.save
      feminine_success_create_message
      redirect_to professors_requests_path
    else
      error_message
      render :new
    end
  end

  private

  def model_human
    'Solicitação'
  end

  def set_orientation
    @orientation = Orientation.find(request_params[:orientation])
  end

  def request_params
    params.require(:orientation).permit(:orientation, :justification)
  end
end
