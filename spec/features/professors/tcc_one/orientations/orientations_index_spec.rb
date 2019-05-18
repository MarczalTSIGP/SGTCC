require 'rails_helper'

describe 'Orientation::index', type: :feature do
  before do
    professor = create(:professor_tcc_one)
    login_as(professor, scope: :professor)
  end

  describe '#index', js: true do
    context 'when shows all the orientations of the current tcc one calendar' do
      it 'shows the orientations' do
        orientation = create(:current_orientation_tcc_one)
        visit professors_orientations_current_tcc_one_path

        expect(page).to have_contents([orientation.short_title,
                                       orientation.advisor.name,
                                       orientation.academic.name,
                                       orientation.calendar.year_with_semester_and_tcc])
      end
    end
  end
end
