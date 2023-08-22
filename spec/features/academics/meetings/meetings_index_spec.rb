require 'rails_helper'

describe 'Meeting::index', type: :feature, js: true do
  let(:academic)    { create(:academic) }
  let(:orientation) { create(:orientation, academic: academic) }

  before do
    create_list(:meeting, 3, orientation: orientation)

    login_as(academic, scope: :academic)
  end

  describe '#index' do
    context 'when shows all meetings' do
      it 'shows all meetings with options' do
        visit academics_meetings_path

        academic.meetings.each do |meeting|
          expect(page).to have_link(orientation.academic_with_calendar,
                                    href: academics_meeting_path(meeting))

          expect(page).to have_content(short_date(meeting.date))
        end
      end
    end
  end
end
