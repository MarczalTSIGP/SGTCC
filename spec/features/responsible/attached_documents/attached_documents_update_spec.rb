require 'rails_helper'

describe 'AttachedDocument::update', :js do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { AttachedDocument.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#update' do
    let(:attached_document) { create(:attached_document) }

    before do
      visit edit_responsible_attached_document_path(attached_document)
    end

    context 'when data is valid' do
      it 'updates the attached_document' do
        attributes = attributes_for(:attached_document)
        fill_in 'attached_document_name', with: attributes[:name]

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_attached_documents_path
        expect(page).to have_flash(:success, text: message('update.m'))
        expect(page).to have_content(attributes[:name])
      end
    end

    context 'when the attached_document is not valid' do
      it 'show errors' do
        fill_in 'attached_document_name', with: ''
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.attached_document_name')
      end
    end
  end
end
