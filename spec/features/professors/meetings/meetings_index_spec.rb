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
        meetings = create_list(:meeting, 3, orientation:)

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
        meetings = [create(:meeting, orientation:, date: 2.days.from_now),
                    create(:meeting, orientation:, date: 1.day.from_now),
                    create(:meeting, orientation:, date: Time.zone.now)]

        visit professors_meetings_path

        within('table.table tbody') do
          meetings.each_with_index do |meeting, index|
            child = index + 1
            base_selector = "tr:nth-child(#{child})"

            expect(page).to have_selector("#{base_selector}
					  a[href='#{professors_meeting_path(meeting)}']",
                                          text: meeting.orientation.academic_with_calendar)
            expect(page).to have_selector(base_selector,
                                          text: short_date(meeting.date))
          end
        end
      end

      it 'shows all meetings by date when created in reverse order' do
        meeting_one = create(:meeting, orientation:, date: Time.zone.now)
	       meeting_two = create(:meeting, orientation:, date: 1.day.from_now)
	       meeting_three = create(:meeting, orientation:, date: 2.days.from_now)
	       meetings = [meeting_three, meeting_two, meeting_one]

        visit professors_meetings_path

        within('table.table tbody') do
          meetings.each_with_index do |meeting, index|
            child = index + 1
            base_selector = "tr:nth-child(#{child})"

            expect(page).to have_selector("#{base_selector}
					a[href='#{professors_meeting_path(meeting)}']",
                                          text: meeting.orientation.academic_with_calendar)
            expect(page).to have_selector(base_selector,
                                          text: short_date(meeting.date))
          end
        end
      end
    end
  end
end
