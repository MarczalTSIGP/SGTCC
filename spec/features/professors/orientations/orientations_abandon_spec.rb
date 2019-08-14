require 'rails_helper'

describe 'Orientation::abandon', type: :feature do
  let!(:professor) { create(:professor) }
  let!(:orientation) { create(:orientation, advisor_id: professor.id) }
  let(:resource_name) { request_resource_name }

  before do
    create(:responsible)
    login_as(professor, scope: :professor)
  end

  describe '#create' do
    before do
      create(:document_type_tdo)
      create(:current_calendar_tcc_one)
      visit new_professors_request_path
    end

    context 'when request is valid', js: true do
      it 'create a term of abandonment' do
        selectize(orientation.academic_with_calendar, from: 'document_orientation_id')
        find('.fa-bold').click
        submit_form('input[name="commit"]')

        expect(page).to have_current_path professors_document_path(Document.last)
        expect(page).to have_flash(:success, text: message('create.f'))
        expect(page).to have_content(orientation.title)
      end
    end

    context 'when request is not valid', js: true do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_message(blank_error_message, in: 'div.document_orientation_id')
        expect(page).to have_message(blank_error_message, in: 'div.document_justification')
      end
    end
  end
end
