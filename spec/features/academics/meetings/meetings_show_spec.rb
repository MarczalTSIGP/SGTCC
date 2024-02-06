require 'rails_helper'

describe 'Meeting::show' do
  let(:academic) { create(:academic) }
  let(:orientation) { create(:orientation, academic:) }
  let(:meeting) { create(:meeting, orientation:) }

  before do
    login_as(academic, scope: :academic)
    visit academics_meeting_path(meeting)
  end

  describe '#show' do
    context 'when shows the meeting' do
      it 'shows the meeting' do
        expect(page).to have_content(complete_date(meeting.date))
      end
    end

    context 'when the meeting cant be viewed' do
      before do
        meeting = create(:meeting)
        visit academics_meeting_path(meeting)
      end

      it 'redirect to the meetings page' do
        expect(page).to have_current_path academics_meetings_path
      end
    end
  end
end
