class Academics::TsoRequestsController < Academics::BaseController
  before_action :set_document, only: [:edit, :update]

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tso.index'),
                 :academics_tso_requests_path

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tso.new'),
                 :new_academics_tso_request_path,
                 only: :new

  def index
    @requests = current_academic.tsos.with_relationships.page(params[:page])
  end

  def new
    @document = Document.new
  end

  def edit; end

  def create
    @document = Document.new_tso(current_academic, request_params)

    if @document.save
      feminine_success_create_message
      redirect_to academics_tso_requests_path
    else
      render :new
    end
  end

  def update
    if @document.update_requester_justification(request_params)
      feminine_success_update_message
      redirect_to academics_document_path(@document)
    else
      error_message
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
    params.require(:document)
          .permit(:justification, :advisor_id,
                  professor_supervisor_ids: [], external_member_supervisor_ids: [])
  end
end
