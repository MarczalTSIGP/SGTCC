class Academics::TepRequestsController < Academics::RequestsController
  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tep.index'),
                 :academics_tep_requests_path

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tep.new'),
                 :new_academics_tep_request_path,
                 only: :new

  add_breadcrumb I18n.t('breadcrumbs.documents.requests.tep.edit'),
                 :edit_academics_tep_request_path,
                 only: :edit

  private

  def requests_scope
    current_academic.teps
  end

  def build_document
    Documents::TypeFactory.new_tep(current_academic, request_params)
  end

  def request_params
    params.expect(document: [:justification])
  end
end
