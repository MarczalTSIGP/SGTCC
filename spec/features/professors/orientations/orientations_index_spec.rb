require 'rails_helper'

describe 'Orientation::index', type: :feature do
  let(:professor) { create(:professor) }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#index', js: true do
    context 'when shows all the orientations of tcc one calendar' do
      it 'shows all the orientations of tcc one with options' do
        orientation = create(:current_orientation_tcc_one, advisor: professor)

        index_url = professors_orientations_tcc_one_path
        visit index_url

        expect(page).to have_contents([orientation.short_title,
                                       orientation.advisor.name,
                                       orientation.academic.name,
                                       orientation.calendar.year_with_semester_and_tcc])
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end

    context 'when shows all the orientations of tcc two calendar' do
      it 'shows all the orientations of tcc two with options' do
        orientation = create(:current_orientation_tcc_two, advisor: professor)

        index_url = professors_orientations_tcc_two_path
        visit index_url

        expect(page).to have_contents([orientation.short_title,
                                       orientation.advisor.name,
                                       orientation.academic.name,
                                       orientation.calendar.year_with_semester_and_tcc])
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end

    context 'when shows all the orientations' do
      it 'shows all the orientations of history' do
        orientation = create(:orientation_tcc_one, advisor: professor)

        index_url = professors_orientations_history_path
        visit index_url

        expect(page).to have_contents([orientation.short_title,
                                       orientation.advisor.name,
                                       orientation.academic.name,
                                       orientation.calendar.year_with_semester_and_tcc])
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end
