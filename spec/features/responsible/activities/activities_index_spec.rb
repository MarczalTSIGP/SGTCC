require 'rails_helper'

describe 'Activity::index', type: :feature do
  describe '#index' do
    before do
      responsible = create(:responsible)
      login_as(responsible, scope: :professor)
    end

    context 'when shows all activities' do
      it 'shows all activities with options', js: true do
        calendar = create(:calendar)

        visit responsible_calendar_activities_path(calendar)

        calendar.activities.each do |activity|
          expect(page).to have_contents([activity.name,
                                         activity.base_activity_type.name,
                                         short_date(activity.created_at)])
        end
      end
    end

    context 'when shows all activities selected by calendar' do
      it 'shows all activities selected by calendar', js: true do
        calendar = create(:calendar_tcc_one, semester: 1)
        second_calendar = create(:calendar_tcc_one, semester: 2)

        visit responsible_calendar_activities_path(calendar)
        find('#activity_calendar-selectized').click
        first('div.option').click
        submit_form('input[name="commit"]')

        second_calendar.activities.each do |activity|
          expect(page).to have_contents([activity.name,
                                         activity.base_activity_type.name,
                                         short_date(activity.created_at)])
        end
      end
    end
  end
end
