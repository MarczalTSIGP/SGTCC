require 'rails_helper'

describe 'Activity::index', type: :feature do
  describe '#index' do
    before do
      responsible = create(:responsible)
      login_as(responsible, scope: :professor)
    end

    context 'when shows all activities with tcc 2' do
      it 'shows all activities with tcc 2 options', js: true do
        calendar = create(:calendar_tcc_two)
        activity = create(:activity_tcc_two, calendar: calendar)

        visit responsible_calendar_activities_tcc_two_index_path(calendar)

        expect(page).to have_contents([activity.name,
                                       activity.base_activity_type.name,
                                       short_date(activity.created_at)])
      end
    end

    context 'when shows all activities with tcc 2 selected by calendar' do
      it 'shows all activities with tcc 2 selected by calendar', js: true do
        calendar = create(:calendar_tcc_two, semester: 1)
        create(:activity_tcc_two, calendar: calendar)
        second_calendar = create(:calendar_tcc_two, semester: 2)
        new_activity = create(:activity_tcc_two, calendar: second_calendar)

        visit responsible_calendar_activities_tcc_two_index_path(calendar)
        find('#activity_calendar-selectized').click
        first('div.option').click

        submit_form('input[name="commit"]')
        expect(page).to have_contents([new_activity.name,
                                       new_activity.base_activity_type.name,
                                       short_date(new_activity.created_at)])
      end
    end
  end
end
