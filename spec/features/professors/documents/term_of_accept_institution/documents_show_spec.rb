require 'rails_helper'

describe 'Signature::show', :js do
  let(:orientation) { create(:orientation) }
  let(:professor) { orientation.advisor }
  let(:document) { Document.last }
  let(:document_path) { professors_document_path(document) }
  let(:pending_documents_path) { professors_documents_pending_path }
  let(:signed_documents_path) { professors_documents_signed_path }
  let(:pending_document_created_at) { orientation.created_at }
  let(:signed_document_created_at) { document.created_at }
  let(:signed_document_extra_contents) do
    [signature_role(professor.gender, 'advisor')]
  end
  let(:unauthorized_document) do
    create(:orientation)
    Document.last
  end
  let(:unauthorized_document_path) { professors_document_path(unauthorized_document) }

  before do
    orientation.signatures << Signature.all
    login_as(professor, scope: :professor)
  end

  describe '#show' do
    context 'when shows the pending document of the term of accept institution' do
      it_behaves_like 'a pending document show page',
                      'the term of accept institution'
    end

    context 'when shows the signed document of the term of accept institution' do
      let(:document_type) { document.document_type }

      it_behaves_like 'a signed document show page',
                      'the term of accept institution'
    end

    context 'when the document signature cant be viewed' do
      it_behaves_like 'an unauthorized document show access',
                      'redirect to the documents pending page'
    end
  end
end
