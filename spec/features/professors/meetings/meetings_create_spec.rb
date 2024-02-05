require 'rails_helper'

describe 'Meeting::create', :js do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let(:resource_name) { Meeting.model_name.human }

  before do
    professor.orientations << orientation
    login_as(professor, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_professors_meeting_path
    end

    context 'when meeting is valid' do
      it 'create a meeting' do
        selectize(orientation.academic_with_calendar, from: 'meeting_orientation_id')
        find('.fa-bold').click
        submit_form('input[name="commit"]')

        expect(page).to have_current_path professors_meetings_path
        expect(page).to have_flash(:success, text: message('create.f'))
        expect(page).to have_message(orientation.academic_with_calendar, in: 'table tbody')
      end
    end

    context 'when meeting is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(required_error_message, in: 'div.meeting_orientation')
      end
    end
  end
end
