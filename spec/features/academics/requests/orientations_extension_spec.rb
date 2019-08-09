require 'rails_helper'

describe 'Orientation::extension', type: :feature do
  let!(:academic) { create(:academic) }
  let!(:orientation) { create(:current_orientation_tcc_two, academic_id: academic.id) }
  let(:resource_name) { request_resource_name }

  before do
    create(:responsible)
    create(:coordinator)
    create(:document_type_tep)
    login_as(academic, scope: :academic)
  end

  describe '#create' do
    before do
      visit new_academics_tep_request_path
    end

    context 'when request is valid', js: true do
      it 'create a term of extension' do
        fill_in 'document_justification', with: 'justification'
        submit_form('input[name="commit"]')

        expect(page).to have_current_path academics_tep_requests_path
        expect(page).to have_flash(:success, text: message('create.f'))
        expect(page).to have_message(orientation.short_title, in: 'table tbody')
      end
    end

    context 'when request is not valid', js: true do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_message(blank_error_message, in: 'div.document_justification')
      end
    end
  end
end
