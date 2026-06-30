require 'rails_helper'

describe 'Document::show', :js do
  let(:orientation) { create(:orientation) }
  let(:document) { orientation.documents.first }
  let(:document_path) { academics_document_path(document) }
  let(:pending_documents_path) { academics_documents_pending_path }
  let(:signed_documents_path) { academics_documents_signed_path }
  let(:pending_document_created_at) { orientation.created_at }
  let(:signed_document_created_at) { orientation.created_at }
  let(:signed_document_extra_contents) do
    [signature_role(orientation.academic.gender, 'academic')]
  end
  let(:unauthorized_document) { create(:orientation).documents.last }
  let(:unauthorized_document_path) { academics_document_path(unauthorized_document) }

  before do
    login_as(orientation.academic, scope: :academic)
  end

  describe '#show' do
    context 'when shows the document of the term of commitment' do
      it_behaves_like 'a pending document show page', 'the term of commitment'
    end

    context 'when shows the signed document of the term of commitment' do
      it_behaves_like 'a signed document show page', 'the term of commitment'
    end

    context 'when the document cant be viewed' do
      it_behaves_like 'an unauthorized document show access',
                      'redirect to the documents pending page'
    end
  end
end
