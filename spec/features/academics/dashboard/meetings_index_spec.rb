require 'rails_helper'

describe 'Meeting::index', type: :feature do
  let(:orientation) { create(:orientation) }

  before do
    create_list(:meeting, 3, orientation: orientation)
    login_as(orientation.academic, scope: :academic)
    visit academics_root_path
  end

  describe '#index' do
    context 'when shows all meetings' do
      it 'shows all meetings with options' do
        orientation.academic.meetings.each do |meeting|
          expect(page).to have_link(meeting.orientation.academic_with_calendar, href: academics_meeting_path(meeting))
          expect(page).to have_contents([short_date(meeting.date),
                                         short_date(meeting.updated_at)])
        end
      end
    end
  end
end
