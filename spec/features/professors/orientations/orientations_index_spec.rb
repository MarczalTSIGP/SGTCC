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

        visit professors_orientations_tcc_one_path

        expect(page).to have_contents([orientation.short_title,
                                       orientation.advisor.name,
                                       orientation.academic.name,
                                       orientation.calendar.year_with_semester_and_tcc])
      end
    end

    context 'when shows all the orientations of tcc two calendar' do
      it 'shows all the orientations of tcc two with options' do
        orientation = create(:current_orientation_tcc_two, advisor: professor)

        visit professors_orientations_tcc_two_path

        expect(page).to have_contents([orientation.short_title,
                                       orientation.advisor.name,
                                       orientation.academic.name,
                                       orientation.calendar.year_with_semester_and_tcc])
      end
    end
  end
end
