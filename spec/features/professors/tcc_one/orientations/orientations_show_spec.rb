require 'rails_helper'

describe 'Orientation::show', type: :feature do
  let(:professor) { create(:professor_tcc_one) }
  let(:orientation) { create(:current_orientation_tcc_one) }

  before do
    login_as(professor, scope: :professor)
    visit professors_calendar_orientation_path(orientation, orientation.calendar)
  end

  describe '#show' do
    it 'shows the current orientation by tcc one' do
      expect(page).to have_contents([orientation.title,
                                     orientation.academic.name,
                                     orientation.advisor.name,
                                     orientation.calendar.year_with_semester,
                                     complete_date(orientation.created_at),
                                     complete_date(orientation.updated_at)])
    end
  end
end
