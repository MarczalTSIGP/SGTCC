class Academics::TsoRequestsController < Academics::BaseController
  before_action :set_document, only: [:edit, :update, :destroy]
  before_action :can_change, only: [:edit, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tso.index'),
                 :academics_tso_requests_path

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tso.new'),
                 :new_academics_tso_request_path,
                 only: :new

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tso.edit'),
                 :edit_academics_tso_request_path,
                 only: :edit

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
      redirect_to academics_document_path(@document)
    else
      render :new
    end
  end

  def update
    if can_destroy_and_update?
      destroy_and_update
    else
      update_justification
    end

    feminine_success_update_message
    redirect_to academics_document_path(@document)
  end

  def destroy
    @document.destroy
    feminine_success_destroy_message

    redirect_to academics_tso_requests_path
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

  def diff_advisor?
    request_params[:advisor_id].to_i != @document.request['new_orientation']['advisor']['id']
  end

  def diff_supervisors?(param_name, request_name)
    supervisor_ids = request_params[param_name]
    supervisor_ids.shift
    supervisor_ids = supervisor_ids.map(&:to_i)
    supervisor_ids != @document.request['new_orientation'][request_name].map do |supervisor|
      supervisor['id']
    end
  end

  def can_destroy_and_update?
    diff_advisor? || diff_supervisors?('professor_supervisor_ids', 'professorSupervisors') ||
      diff_supervisors?('external_member_supervisor_ids', 'externalMemberSupervisors')
  end

  def destroy_and_update
    @document.destroy
    @document = Document.new_tso(current_academic, request_params)
    @document.save
  end

  def update_justification
    @document.update_requester_justification(request_params)
  end

  def can_change
    return unless @document.academic_signed?(current_academic)
    flash[:alert] = I18n.t('flash.documents.academics.requests.not_allowed')
    redirect_to academics_tso_requests_path
  end
end
