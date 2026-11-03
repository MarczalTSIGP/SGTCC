class Academics::TsoRequestsController < Academics::RequestsController
  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tso.index'),
                 :academics_tso_requests_path

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tso.new'),
                 :new_academics_tso_request_path,
                 only: :new

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tso.edit'),
                 :edit_academics_tso_request_path,
                 only: :edit

  private

  def requests_scope
    current_academic.tsos
  end

  def build_document
    Documents::TypeFactory.new_tso(current_academic, request_params)
  end

  def request_params
    params
      .expect(document: [:justification, :advisor_id,
                         { professor_supervisor_ids: [], external_member_supervisor_ids: [] }])
  end

  # Só o TSO pede troca de orientação. Quando orientador ou supervisores mudam,
  # o documento é recriado em vez de atualizado, porque o `request` gravado
  # descreve a nova orientação inteira.
  def update_document
    return super unless can_destroy_and_update?

    # O resultado do save não é verificado, como antes desta task: a troca segue
    # para o fluxo de sucesso mesmo que a recriação falhe.
    destroy_and_update
    true
  end

  def diff_advisor?
    request_params[:advisor_id].to_i != @document.request['new_orientation']['advisor']['id']
  end

  def diff_supervisors?(param_name, request_name)
    supervisor_ids = request_params[param_name]
    supervisor_ids.shift
    supervisor_ids = supervisor_ids.map(&:to_i)
    supervisor_ids != @document.request['new_orientation'][request_name].pluck('id')
  end

  def can_destroy_and_update?
    diff_advisor? || diff_supervisors?('professor_supervisor_ids', 'professorSupervisors') ||
      diff_supervisors?('external_member_supervisor_ids', 'externalMemberSupervisors')
  end

  def destroy_and_update
    @document.destroy
    @document = Documents::TypeFactory.new_tso(current_academic, request_params)
    @document.save
  end
end
