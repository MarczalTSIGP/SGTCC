class Professors::RequestsController < Professors::BaseController
  add_breadcrumb I18n.t('breadcrumbs.documents.requests.index'),
                 :professors_requests_path

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.new'),
                 :new_professors_request_path,
                 only: :new

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.show'),
                 :professors_request_path,
                 only: :show

  def index
    @requests = []
  end

  def show; end

  def new
    @document = Document.new
  end

  def create
    if @document.create_request(request_params)
      success_create_message
      redirect_to professors_requests_path
    else
      error_message
      render :new
    end
  end

  private

  def request_params
    params.require(:orientation).permit(:orientation, :justification)
  end
end
