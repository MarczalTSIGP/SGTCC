require 'rails_helper'

describe 'AttachedDocuments::create', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { AttachedDocument.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_responsible_attached_document_path
    end

    context 'when attached_document is valid' do
      it 'create an attached_document' do
        attributes = attributes_for(:attached_document)
        fill_in 'attached_document_name', with: attributes[:name]
        attach_file 'attached_document_file', FileSpecHelper.pdf.path
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_attached_documents_path
        expect(page).to have_flash(:success, text: message('create.m'))
        expect(page).to have_message(attributes[:name], in: 'table tbody')
      end
    end

    context 'when attached_document is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.attached_document_name')
        expect(page).to have_message(blank_error_message, in: 'div.attached_document_file')
      end
    end
  end
end
