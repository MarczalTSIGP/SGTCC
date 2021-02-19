require 'rails_helper'

describe 'Orientation::show', type: :feature do
  let(:professor) { create(:professor_tcc_one) }
  let!(:orientation) { create(:current_orientation_tcc_one) }

  before do
    login_as(professor, scope: :professor)
    visit tcc_one_professors_calendar_orientation_path(orientation.current_calendar, orientation)
  end

  describe '#show' do
    it 'shows the current orientation by tcc one' do
      expect(page).to have_content(orientation.title)
      expect(page).to have_content(orientation.academic.name)
      expect(page).to have_content(orientation.advisor.name)

      orientation.calendars.each do |calendar|
        expect(page).to have_content(calendar.year_with_semester_and_tcc)
      end

      expect(page).to have_content(complete_date(orientation.created_at))
      expect(page).to have_content(complete_date(orientation.updated_at))
    end
  end
end
