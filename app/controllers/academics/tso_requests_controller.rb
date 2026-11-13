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
  # descreve a nova orientação inteira. A comparação é do Form Object (REF-29).
  def update_document
    return super unless Documents::TsoRequestForm.new(request_params)
                                                 .orientation_changed?(@document)

    destroy_and_update
  end

  # O documento novo é criado antes de o antigo ser apagado, na mesma transação. Se o novo
  # for inválido, o antigo permanece, e o `update` do pai reexibe o formulário com o erro.
  def destroy_and_update
    replacement = Documents::TypeFactory.new_tso(current_academic, request_params)
    replaced = replace_document(replacement)

    if replaced
      @document = replacement
    else
      replacement.errors.each { |error| @document.errors.add(error.attribute, error.message) }
    end

    replaced
  end

  def replace_document(replacement)
    Document.transaction do
      next false unless replacement.save

      @document.destroy!
      true
    end
  end
end
