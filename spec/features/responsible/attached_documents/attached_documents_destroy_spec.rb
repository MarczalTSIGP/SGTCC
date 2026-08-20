require 'rails_helper'

describe 'AttachedDocument::destroy', :js do
  let(:responsible) { create(:responsible) }
  let!(:attached_document) { create(:attached_document) }
  let(:resource_name) { AttachedDocument.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_attached_documents_path
  end

  describe '#destroy' do
    context 'when attached_document is destroyed' do
      let(:destroy_path) { responsible_attached_document_path(attached_document) }
      let(:destroyed_record_name) { attached_document.name }

      it_behaves_like 'responsible destroy success flow', message_key: 'destroy.m'
    end
  end
end
