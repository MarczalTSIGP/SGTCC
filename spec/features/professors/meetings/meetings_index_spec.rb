require 'rails_helper'

describe 'Meeting::index', type: :feature, js: true do
  let(:professor)   { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#index' do
    context 'when shows all meetings' do
      it 'shows all meetings with options' do
        meetings = create_list(:meeting, 3, orientation: orientation)

        visit professors_meetings_path

        meetings.each do |meeting|
          expect(page).to have_link(orientation.academic_with_calendar,
                                    href: professors_meeting_path(meeting))
          expect(page).to have_contents([short_date(meeting.date)])
        end
      end
    end

    context 'when shows all meetings by orientation' do
      it 'shows all meetings by orientation with options' do
        visit professors_orientation_meetings_path(orientation)

        orientation.meetings.each do |meeting|
          expect(page).to have_link(orientation.academic_with_calendar,
                                    href: professors_meeting_path(meeting))

          expect(page).to have_contents([meeting.orientation.academic_with_calendar,
                                         short_date(meeting.date)])
        end
      end
    end

    context 'when shows all meetings by date' do
      it 'shows all meetings by date when created in order' do
        meetings = [create(:meeting, orientation: orientation, date: 2.days.from_now),
                    create(:meeting, orientation: orientation, date: 1.days.from_now),
                    create(:meeting, orientation: orientation, date: Time.now)]

        visit professors_meetings_path

        within('table.table tbody') do
          meetings.each_with_index do |meeting, index|
            child = index + 1
            base_selector = "tr:nth-child(#{child})"

            expect(page).to have_selector("#{base_selector} a[href='#{professors_meeting_path(meeting)}']",
                                          text: meeting.orientation.academic_with_calendar)
            expect(page).to have_selector(base_selector,
                                          text: short_date(meeting.date))
          end
        end
      end
      it 'shows all meetings by date when created in reverse order' do
        meeting1 = create(:meeting, orientation: orientation, date: Time.now)
	meeting2 = create(:meeting, orientation: orientation, date: 1.days.from_now)
	meeting3 = create(:meeting, orientation: orientation, date: 2.days.from_now)

	meetings = [meeting3, meeting2, meeting1]

        visit professors_meetings_path

        within('table.table tbody') do
          meetings.each_with_index do |meeting, index|
          child = index + 1
          base_selector = "tr:nth-child(#{child})"

          expect(page).to have_selector("#{base_selector} a[href='#{professors_meeting_path(meeting)}']",
                                        text: meeting.orientation.academic_with_calendar)
          expect(page).to have_selector(base_selector,
                                        text: short_date(meeting.date))
          end
        end
      end
    end
  end
end
