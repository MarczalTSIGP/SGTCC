require 'rails_helper'

describe 'Orientation::abandon', type: :feature do
  let(:orientation) { create(:orientation) }
  let(:professor) { orientation.advisor }
  let(:resource_name) { Orientation.model_name.human }

  before do
    create(:document_tdo)
    create(:current_calendar_tcc_one)
    login_as(professor, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_professors_request_path
    end

    context 'when request is valid', js: true do
      it 'create a term of abandonment' do
        selectize(orientation.academic_with_calendar, from: 'orientation_orientation_id')
        fill_in 'orientation_justification', with: 'justification'
        submit_form('input[name="commit"]')

        expect(page).to have_current_path professors_requests_path
        expect(page).to have_flash(:success, text: message('create.f'))
        expect(page).to have_message(orientation.title, in: 'table tbody')
      end
    end

    context 'when request is not valid', js: true do
      it 'show errors' do
      end
    end
  end
end
