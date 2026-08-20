require 'rails_helper'

describe 'Document::show', :js do
  let(:orientation) { create(:orientation) }
  let(:external_member) { orientation.external_member_supervisors.first }
  let(:document) { Document.last }
  let(:document_path) { external_members_document_path(document) }
  let(:pending_documents_path) { external_members_documents_pending_path }
  let(:signed_documents_path) { external_members_documents_signed_path }
  let(:pending_document_created_at) { orientation.created_at }
  let(:signed_document_created_at) { orientation.created_at }
  let(:signed_document_extra_contents) do
    [signature_role(external_member.gender, 'external_member_supervisor')]
  end
  let(:unauthorized_document) do
    create(:orientation)
    Document.last
  end
  let(:unauthorized_document_path) do
    external_members_document_path(unauthorized_document)
  end

  before do
    orientation.signatures << Signature.all
    login_as(external_member, scope: :external_member)
  end

  describe '#show' do
    context 'when shows the document of the term of accept institution' do
      it_behaves_like 'a pending document show page',
                      'the term of accept institution'
    end

    context 'when shows the signed signature of the term of accept institution' do
      let(:document_type) { document.document_type }

      it_behaves_like 'a signed document show page',
                      'the term of accept institution'
    end

    context 'when the document cant be viewed' do
      it_behaves_like 'an unauthorized document show access',
                      'redirect to the signature pending page'
    end
  end
end
