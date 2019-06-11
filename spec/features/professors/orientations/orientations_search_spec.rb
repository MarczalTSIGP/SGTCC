require 'rails_helper'

describe 'Orientation::search', type: :feature do
  let(:professor) { create(:professor) }
  let!(:first_orientation) { create(:current_orientation_tcc_one, advisor: professor) }

  before do
    login_as(professor, scope: :professor)
    visit professors_orientations_tcc_one_path
  end

  describe '#search', js: true do
    context 'when finds the orientation' do
      it 'finds the orientation by the title' do
        fill_in 'term', with: first_orientation.title
        first('#search').click

        expect(page).to have_contents([first_orientation.short_title,
                                       first_orientation.advisor.name,
                                       first_orientation.academic.name,
                                       first_orientation.academic.ra,
                                       first_orientation.calendar.year_with_semester_and_tcc])
      end

      it 'finds the orientation by status' do
        selectize(orientation_in_progress_option, from: 'orientation_status')
        expect(page).to have_contents([first_orientation.short_title,
                                       first_orientation.advisor.name,
                                       first_orientation.academic.name,
                                       first_orientation.academic.ra,
                                       first_orientation.calendar.year_with_semester_and_tcc])
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
