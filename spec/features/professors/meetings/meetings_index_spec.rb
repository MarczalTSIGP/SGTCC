require 'rails_helper'

describe 'Meeting::index', type: :feature, js: true do
  let(:professor) { create(:professor) }
  let!(:meetings) { create_list(:meeting, 3) }

  before do
    professor.orientations << Orientation.all
    login_as(professor, scope: :professor)
  end

  describe '#index' do
    context 'when shows all meetings' do
      it 'shows all meetings with options' do
        visit professors_meetings_path
        meetings.each do |meeting|
          expect(page).to have_link(meeting.orientation.academic_with_calendar,
                                    href: professors_meeting_path(meeting))
          expect(page).to have_contents([short_date(meeting.date)])
        end
      end
    end

    context 'when shows all meetings by orientation' do
      let(:orientation) { professor.orientations.first }

      it 'shows all meetings by orientation with options' do
        visit professors_orientation_meetings_path(orientation)

        orientation.meetings.each do |meeting|
          expect(page).to have_contents([meeting.orientation.academic_with_calendar,
                                         short_date(meeting.date)])
        end
      end
    end
  end
end
