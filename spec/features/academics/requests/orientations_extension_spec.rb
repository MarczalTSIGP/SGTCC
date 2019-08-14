require 'rails_helper'

describe 'Orientation::extension', type: :feature, js: true do
  let!(:academic) { create(:academic) }
  let(:resource_name) { request_resource_name }

  before do
    create(:current_orientation_tcc_two, academic_id: academic.id)
    create(:responsible)
    create(:coordinator)
    login_as(academic, scope: :academic)
  end

  describe '#create' do
    let!(:document_type) { create(:document_type_tep) }

    before do
      visit new_academics_tep_request_path
    end

    context 'when request is valid' do
      it 'create a term of extension' do
        find('.fa-bold').click
        submit_form('input[name="commit"]')

        expect(page).to have_current_path academics_document_path(Document.last)
        expect(page).to have_flash(:success, text: message('create.f'))
        expect(page).to have_contents([academic.name,
                                       document_type.name.upcase])
      end
    end

    context 'when request is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_message(blank_error_message, in: 'div.document_justification')
      end
    end
  end

  describe '#update' do
    let!(:orientation) { create(:orientation, academic: academic) }
    let!(:document_tep) { create(:document_tep, orientation_id: orientation.id) }
    let(:new_justification) { "**#{document_tep.request['requester']['justification']}" }

    before do
      visit edit_academics_tep_request_path(document_tep)
    end

    context 'when request is valid' do
      it 'updates the justification of the term of extension' do
        find('.fa-italic').click
        submit_form('input[name="commit"]')

        expect(page).to have_current_path academics_document_path(document_tep)
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(page).to have_contents([academic.name,
                                       document_tep.document_type.name.upcase,
                                       new_justification])
      end
    end
  end
end
