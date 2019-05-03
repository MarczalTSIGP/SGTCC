require 'rails_helper'

describe 'Orientation::index', type: :feature do
  let(:professor) { create(:professor) }
  let!(:orientations) { create_list(:orientation, 3) }

  before do
    login_as(professor, scope: :professor)
    visit professors_orientations_path
  end

  describe '#index' do
    context 'when shows all the orientations' do
      it 'shows all the orientations with options', js: true do
        orientations.each do |orientation|
          expect(page).to have_contents([orientation.short_title,
                                         orientation.advisor.name,
                                         orientation.academic.name,
                                         orientation.calendar.year_with_semester_and_tcc])
        end
      end
    end
  end
end
