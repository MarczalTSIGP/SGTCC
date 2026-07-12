require 'rails_helper'

describe 'Orientation::search' do
  let(:responsible) { create(:responsible) }
  let!(:orientations) { create_list(:orientation, 2, :tcc_one) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_orientations_tcc_one_path
  end

  describe '#search', :js do
    context 'when finds the orientation' do
      it 'finds the orientation by the title' do
        orientation = orientations.first

        fill_in 'term', with: orientation.title
        find_by_id('search').click

        expect(page).to have_css('table tbody tr:nth-child(1)',
                                 text: orientation.short_title)

        # expect(page).to have_contents([orientation.short_title,
        #                                orientation.advisor.name,
        #                                orientation.academic.name,
        #                                orientation.academic.ra,
        #                                orientation.calendar.year_with_semester_and_tcc])

        within('table tbody tr:nth-child(1)') do
          expect(page).to have_text(orientation.short_title)
          expect(page).to have_text(orientation.advisor.name)
          expect(page).to have_link(orientation.academic.name,
                                    href: responsible_orientation_path(orientation))
          expect(page).to have_text(orientation.academic.ra)

          orientation.calendars.each do |calendar|
            expect(page).to have_text(calendar.year_with_semester_and_tcc)
          end
        end
      end

      it 'finds the orientation by status' do
        visit responsible_orientations_tcc_two_path
        calendar = create(:calendar, :current, :tcc_two)
        orientation = create(:orientation, :approved, calendars: [calendar])
        slim_select(orientation_approved_option, from: 'orientation_status')

        within('table tbody tr:nth-child(1)') do
          expect(page).to have_text(orientation.short_title)
          expect(page).to have_text(orientation.advisor.name)
          expect(page).to have_text(orientation.academic.name)
          expect(page).to have_text(orientation.academic.ra)

          orientation.calendars.each do |cal|
            expect(page).to have_text(cal.year_with_semester_and_tcc)
          end
        end
        # expect(page).to have_contents([orientation.short_title,
        #                                orientation.advisor.name,
        #                                orientation.academic.name,
        #                                orientation.academic.ra,
        #                                orientation.calendar.year_with_semester_and_tcc])
      end
    end

    context 'when the result is not found' do
      it 'returns not found message' do
        fill_in 'term', with: 'a1#\231/ere'
        first('#search').click
        expect(page).to have_message(no_results_message, in: 'table tbody')
      end
    end
  end
end
