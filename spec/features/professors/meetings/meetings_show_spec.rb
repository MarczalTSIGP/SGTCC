require 'rails_helper'

describe 'Meeting::show', type: :feature do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let(:meeting) { create(:meeting, orientation: orientation) }

  before do
    login_as(professor, scope: :professor)
    visit professors_meeting_path(meeting)
  end

  describe '#show' do
    context 'when shows the meeting' do
      it 'shows the meeting' do
        expect(page).to have_contents([meeting.title,
                                       complete_date(meeting.created_at),
                                       complete_date(meeting.updated_at)])
      end
    end
  end
end
