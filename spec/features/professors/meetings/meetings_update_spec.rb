require 'rails_helper'

describe 'Meeting::update', :js do
  let(:professor) { create(:professor) }
  let(:resource_name) { Meeting.model_name.human }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#update' do
    let!(:new_orientation) { create(:orientation, advisor: professor) }
    let(:orientation) { create(:orientation, advisor: professor) }

    context 'when data is valid' do
      let(:meeting) { create(:meeting, orientation:) }

      before do
        professor.orientations << orientation
        visit edit_professors_meeting_path(meeting)
      end

      it 'updates the meeting' do
        selectize(new_orientation.academic_with_calendar, from: 'meeting_orientation_id')
        submit_form('input[name="commit"]')

        expect(page).to have_current_path professors_meeting_path(meeting)
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(page).to have_content(new_orientation.academic_with_calendar)
      end
    end

    context 'when the meeting cant be edited' do
      let(:meeting) { create(:meeting, orientation:, viewed: true) }

      before do
        visit edit_professors_meeting_path(meeting)
      end

      it 'redirect to the meetings page' do
        expect(page).to have_current_path professors_meetings_path
        expect(page).to have_flash(:warning, text: meeting_edit_warning_message)
      end
    end
  end
end
