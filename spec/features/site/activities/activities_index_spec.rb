require 'rails_helper'

describe 'Activity::index', type: :feature, js: true do
  before do
    create(:page, url: 'atividades')
  end

  describe '#index' do
    let(:activities_url) { site_activities_path }
    let!(:calendar_tcc_one) { create(:current_calendar_tcc_one) }
    let!(:activity_tcc_one) { create(:activity_tcc_one, calendar: calendar_tcc_one) }
    let!(:calendar_tcc_two) { create(:current_calendar_tcc_two) }
    let!(:activity_tcc_two) { create(:activity_tcc_two, calendar: calendar_tcc_two) }

    context 'when shows all activities for tcc one' do
      it 'shows all activities for tcc one' do
        visit activities_url
        expect(page).to have_contents([activity_tcc_one.name,
                                       activity_tcc_one.base_activity_type.name,
                                       activity_tcc_one.deadline])
        expect(page).to have_selector("a[href='#{activities_url}'].active")
      end
    end

    context 'when shows all activities for tcc two' do
      it 'shows all activities for tcc two' do
        visit activities_url
        expect(page).to have_contents([activity_tcc_two.name,
                                       activity_tcc_two.base_activity_type.name,
                                       activity_tcc_two.deadline])
        expect(page).to have_selector("a[href='#{activities_url}'].active")
      end
    end
  end
end
