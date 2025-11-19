require 'rails_helper'

describe 'Orientation::to_migrate' do
  let!(:current_calendar_tcc_one) do
    Calendar.find_by(year: 2025, semester: 2, tcc: Calendar.tccs[:one]) || 
    create(:current_calendar_tcc_one)
  end

  before do
    responsible = create(:responsible)
    login_as(responsible, scope: :professor)
  end

  describe '#to_migrate', :js do
    let!(:orientations) do
      create_list(:orientation_tcc_one_approved, 2, calendars: [current_calendar_tcc_one])
    end
    
    let(:index_url) { responsible_orientations_migration_path }

    before do
      visit index_url
    end

    it 'shows all orientations that need to be migrated' do
      orientations.each do |orientation|
        expect(page).to have_content(orientation.academic.name)
      end
    end

    it 'display buttons to migrate orientations' do
      buttons = page.all('input[type=submit]')
      expect(buttons.size).to eq(orientations.size)
      expect(buttons.first.value).to eq(I18n.t('views.buttons.migrate'))
    end

    it 'does not show orientations already migrated' do
      base_calendar = orientations.first.current_calendar
      next_calendar = create(:calendar, 
                             year: base_calendar.year.to_i + 1, 
                             semester: 1, 
                             tcc: Calendar.tccs[:two])
      
      expect(page).to have_no_content(next_calendar.year_with_semester_and_tcc)
    end
  end
end
