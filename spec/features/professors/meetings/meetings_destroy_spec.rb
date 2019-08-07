require 'rails_helper'

describe 'Meeting::destroy', type: :feature, js: true do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let!(:meeting) { create(:meeting, orientation: orientation) }
  let(:resource_name) { Meeting.model_name.human }

  before do
    login_as(professor, scope: :professor)
    visit professors_meetings_path
  end

  describe '#destroy' do
    context 'when meeting is destroyed' do
      it 'show success message' do
        click_on_destroy_link(professors_meeting_path(meeting))
        accept_alert
        expect(page).to have_flash(:success, text: message('destroy.f'))
        expect(page).not_to have_content(meeting.orientation.academic_with_calendar)
      end
    end

    context 'when the meeting cant be destroyed' do
      let(:meeting) { create(:meeting, orientation: orientation) }

      before do
        click_on_destroy_link(professors_meeting_path(meeting))
        meeting.update_viewed
        accept_alert
      end

      it 'redirect to the meetings page' do
        expect(page).to have_current_path professors_meetings_path
        expect(page).to have_flash(:warning, text: meeting_destroy_warning_message)
      end
    end
  end
end
