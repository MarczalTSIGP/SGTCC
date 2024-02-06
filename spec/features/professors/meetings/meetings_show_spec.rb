require 'rails_helper'

describe 'Meeting::show' do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let(:meeting) { create(:meeting, orientation:) }

  before do
    login_as(professor, scope: :professor)
    visit professors_meeting_path(meeting)
  end

  describe '#show' do
    context 'when shows the meeting' do
      it 'shows the meeting' do
        expect(page).to have_contents([meeting.orientation.academic_with_calendar,
                                       meeting.orientation.title,
                                       complete_date(meeting.date),
                                       complete_date(meeting.created_at),
                                       complete_date(meeting.updated_at)])
      end
    end

    context 'when the meeting cant be viewed' do
      before do
        meeting = create(:meeting)
        visit professors_meeting_path(meeting)
      end

      it 'redirect to the meetings page' do
        expect(page).to have_current_path professors_meetings_path
      end
    end
  end
end
