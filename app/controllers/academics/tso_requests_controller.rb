class Academics::TsoRequestsController < Academics::BaseController
  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tso.index'),
                 :academics_tso_requests_path

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tso.new'),
                 :new_academics_tso_request_path,
                 only: :new

  def index
    @requests = current_academic.signatures(DocumentType.tso.first)
                                .with_relationships.page(params[:page])
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new_tso(current_academic, request_params)

    if @document.save
      feminine_success_create_message
      redirect_to academics_tso_requests_path
    else
      render :new
    end
  end

  private

  def model_human
    I18n.t('flash.request.index')
  end

  def request_params
    params.require(:document)
          .permit(:justification, :advisor_id,
                  professor_supervisor_ids: [], external_member_supervisor_ids: [])
  end
end
