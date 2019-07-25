require 'rails_helper'

describe 'Orientation::create', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:academic) { create(:academic) }
  let!(:professor) { create(:professor) }
  let!(:calendar) { create(:calendar) }
  let(:resource_name) { Orientation.model_name.human }

  before do
    create(:document_type_tco)
    create(:document_type_tcai)

    login_as(responsible, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_responsible_orientation_path
    end

    context 'when orientation is valid', js: true do
      it 'create an orientation' do
        attributes = attributes_for(:orientation)
        fill_in 'orientation_title', with: attributes[:title]
        selectize(calendar.year_with_semester_and_tcc, from: 'orientation_calendar_id')
        selectize(academic.name, from: 'orientation_academic_id')
        selectize(professor.name, from: 'orientation_advisor_id')
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_orientations_tcc_one_path
        expect(page).to have_flash(:success, text: message('create.f'))
        expect(page).to have_message(attributes[:name], in: 'table tbody')
      end
    end

    context 'when orientation is not valid', js: true do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.orientation_title')
        expect(page).to have_message(required_error_message, in: 'div.orientation_calendar')
        expect(page).to have_message(required_error_message, in: 'div.orientation_academic')
        expect(page).to have_message(required_error_message, in: 'div.orientation_advisor')
      end
    end
  end
end
