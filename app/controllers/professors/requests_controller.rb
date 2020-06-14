class Professors::RequestsController < Professors::BaseController
  before_action :set_document, only: [:edit, :update, :destroy]
  before_action :can_change, only: [:edit, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.index'),
                 :professors_requests_path

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tdo.new'),
                 :new_professors_request_path,
                 only: :new

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tdo.edit'),
                 :edit_professors_request_path,
                 only: :edit

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
    orientation_id = request_params[:orientation_id].to_i
    document_orientation_id = @document.orientation.id

    if orientation_id == document_orientation_id
      update_justification
    elsif orientation_id.present? && document_orientation_id != orientation_id
      destroy_and_create
    end
  end

  def destroy
    @document.destroy
    feminine_success_destroy_message

    redirect_to professors_requests_path
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

  def update_justification
    @document.update_requester_justification(request_params)
    feminine_success_update_message
    redirect_to professors_document_path(@document)
  end

  def destroy_and_create
    @document.destroy
    @document = Document.new_tdo(current_professor, request_params)
    @document.save
    feminine_success_update_message
    redirect_to professors_document_path(@document)
  end

  def can_change
    return unless @document.professor_signed?(current_professor)

    flash[:alert] = I18n.t('flash.documents.professors.requests.not_allowed')
    redirect_to professors_requests_path
  end
end
