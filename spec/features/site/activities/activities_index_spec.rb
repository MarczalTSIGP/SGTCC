require 'rails_helper'

describe 'Site::calendar', type: :feature, js: true do
  before do
    create(:page, url: 'calendario')
  end

  describe '#index' do
    let!(:calendar_tcc_one) { create(:current_calendar_tcc_one) }
    let!(:activity_tcc_one) { create(:activity_tcc_one, calendar: calendar_tcc_one) }
    let!(:calendar_tcc_two) { create(:current_calendar_tcc_two) }
    let!(:activity_tcc_two) { create(:activity_tcc_two, calendar: calendar_tcc_two) }

    before do
      visit site_calendar_path
    end

    it 'shows all activities for tcc one' do
      within('table.tcc_one') do
        expect(page).to have_contents([activity_tcc_one.name,
                                       activity_tcc_one.base_activity_type.name,
                                       activity_tcc_one.deadline])
      end
    end

    it 'shows all activities for tcc two' do
      visit site_calendar_path

      within('table.tcc_two') do
        expect(page).to have_contents([activity_tcc_two.name,
                                       activity_tcc_two.base_activity_type.name,
                                       activity_tcc_two.deadline])
      end
    end

    it 'active calendar link' do
      expect(page).to have_selector("a[href='#{site_calendar_path}'].active")
    end
  end
end
