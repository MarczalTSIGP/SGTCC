class Academics::TepRequestsController < Academics::BaseController
  before_action :set_document, only: [:edit, :update]

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tep.index'),
                 :academics_tep_requests_path

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tep.new'),
                 :new_academics_tep_request_path,
                 only: :new

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tep.edit'),
                 :edit_academics_tep_request_path,
                 only: :edit

  def index
    @requests = current_academic.teps.with_relationships.page(params[:page])
  end

  def new
    @document = Document.new
  end

  def edit; end

  def create
    @document = Document.new_tep(current_academic, request_params)

    if @document.save
      feminine_success_create_message
      redirect_to academics_document_path(@document)
    else
      render :new
    end
  end

  def update
    if @document.update_requester_justification(request_params)
      feminine_success_update_message
      redirect_to academics_document_path(@document)
    else
      render :edit
    end
  end

  private

  def set_document
    @document = current_academic.documents.find_by(id: params[:id])
  end

  def model_human
    I18n.t('flash.request.index')
  end

  def request_params
    params.require(:document).permit(:justification)
  end
end
