require 'rails_helper'

describe 'Orientation::search', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:orientations) { create_list(:orientation_tcc_one, 2) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_orientations_tcc_one_path
  end

  describe '#search', js: true do
    context 'when finds the orientation' do
      it 'finds the orientation by the title' do
        orientation = orientations.first
        fill_in 'term', with: orientation.title
        first('#search').click

        # expect(page).to have_contents([orientation.short_title,
        #                                orientation.advisor.name,
        #                                orientation.academic.name,
        #                                orientation.academic.ra,
        #                                orientation.calendar.year_with_semester_and_tcc])

        within('table tbody tr:nth-child(1)') do
          expect(page).to have_content(orientation.short_title)
          expect(page).to have_content(orientation.advisor.name)
          expect(page).to have_content(orientation.academic.name)
          expect(page).to have_content(orientation.academic.ra)

          orientation.calendars.each do |calendar|
            expect(page).to have_content(calendar.year_with_semester_and_tcc)
          end
        end
      end

      it 'finds the orientation by status' do
        visit responsible_orientations_tcc_two_path
        calendar = create(:current_calendar_tcc_two)
        orientation = create(:orientation_renewed, calendars: [calendar])
        selectize(orientation_renewed_option, from: 'orientation_status')


        within('table tbody tr:nth-child(1)') do
          expect(page).to have_content(orientation.short_title)
          expect(page).to have_content(orientation.advisor.name)
          expect(page).to have_content(orientation.academic.name)
          expect(page).to have_content(orientation.academic.ra)

          orientation.calendars.each do |calendar|
            expect(page).to have_content(calendar.year_with_semester_and_tcc)
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
