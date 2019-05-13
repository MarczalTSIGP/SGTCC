require 'rails_helper'

describe 'Activity::index', type: :feature, js: true do
  let!(:activities) { create_list(:activity, 2) }

  describe '#index' do
    before do
      responsible = create(:responsible)
      login_as(responsible, scope: :professor)
    end

    context 'when shows all activities' do
      it 'shows all activities for tcc one with options' do
        calendar = create(:current_calendar_tcc_one)
        calendar.activities << activities

        index_url = responsible_calendar_activities_path(calendar)
        visit index_url

        activities.each do |activity|
          expect(page).to have_contents([activity.name,
                                         activity.base_activity_type.name,
                                         activity.deadline])
        end

        expect(page).to have_selector("a[href='#{index_url}'].active")
      end

      it 'shows all activities for tcc two with options' do
        calendar = create(:current_calendar_tcc_two)
        calendar.activities << activities

        index_url = responsible_calendar_activities_path(calendar)
        visit index_url

        activities.each do |activity|
          expect(page).to have_contents([activity.name,
                                         activity.base_activity_type.name,
                                         activity.deadline])
        end
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end

    context 'when shows all activities selected by calendar' do
      it 'shows all activities selected by calendar' do
        calendar = create(:calendar_tcc_one, semester: 1)
        second_calendar = create(:calendar_tcc_one, semester: 2)
        second_calendar.activities << activities

        visit responsible_calendar_activities_path(calendar)
        selectize(second_calendar.year_with_semester, from: 'activity_calendar')

        activities.each do |activity|
          expect(page).to have_contents([activity.name,
                                         activity.base_activity_type.name,
                                         activity.deadline])
        end
      end
    end

    context 'when shows all activities by the next calendar' do
      it 'shows all activities by the next calendar' do
        calendar = create(:current_calendar_tcc_one, semester: 1)
        second_calendar = create(:current_calendar_tcc_one, semester: 2)
        second_calendar.activities << activities

        visit responsible_calendar_activities_path(calendar)
        find('#next_calendar').click

        activities.each do |activity|
          expect(page).to have_contents([activity.name,
                                         activity.base_activity_type.name,
                                         activity.deadline])
        end
      end
    end
  end
end
