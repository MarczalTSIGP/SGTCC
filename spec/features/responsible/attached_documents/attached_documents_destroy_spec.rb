require 'rails_helper'

describe 'AttachedDocument::destroy', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let!(:attached_document) { create(:attached_document) }
  let(:resource_name) { AttachedDocument.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_attached_documents_path
  end

  describe '#destroy' do
    context 'when attached_document is destroyed' do
      it 'show success message' do
        click_on_destroy_link(responsible_attached_document_path(attached_document))
        accept_alert
        expect(page).to have_flash(:success, text: message('destroy.m'))
        expect(page).not_to have_content(attached_document.name)
      end
    end
  end
end
