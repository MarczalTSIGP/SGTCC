require 'rails_helper'

describe 'Meeting::index', :js do
  let(:professor)   { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#index' do
    context 'when shows all meetings' do
      it 'shows all meetings with options' do
        meetings = create_list(:meeting, 3, orientation: orientation)

        visit professors_root_path

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
