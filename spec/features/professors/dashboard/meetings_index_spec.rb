require 'rails_helper'

describe 'Meeting::index', type: :feature, js: true do
  let(:professor) { create(:professor) }
  let!(:meetings) { create_list(:meeting, 3) }

  before do
    professor.orientations << Orientation.all
    login_as(professor, scope: :professor)
    visit professors_root_path
  end

  describe '#index' do
    context 'when shows all meetings' do
      it 'shows all meetings with options' do
        meetings.each do |meeting|
          expect(page).to have_link(meeting.orientation.academic_with_calendar,
                                    href: professors_meeting_path(meeting))
          expect(page).to have_contents([short_date(meeting.date),
                                         short_date(meeting.updated_at)])
        end
      end
    end
  end
end
