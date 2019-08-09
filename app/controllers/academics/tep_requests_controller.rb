class Academics::TepRequestsController < Academics::BaseController
  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tep.index'),
                 :academics_tep_requests_path

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tep.new'),
                 :new_academics_tep_request_path,
                 only: :new

  def index
    @requests = current_academic.teps.with_relationships.page(params[:page])
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new_tep(current_academic, request_params)

    if @document.save
      feminine_success_create_message
      redirect_to academics_tep_requests_path
    else
      render :new
    end
  end

  private

  def model_human
    I18n.t('flash.request.index')
  end

  def request_params
    params.require(:document).permit(:justification)
  end
end
