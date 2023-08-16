require 'rails_helper'

describe 'Activity::index', type: :feature, js: true do
  describe '#index' do
    before do
      responsible = create(:responsible)
      login_as(responsible, scope: :professor)
    end

    context 'when shows all activities' do
      it 'shows all activities for tcc one with options' do
        calendar = create(:current_calendar_tcc_one)
        activity = create(:activity_tcc_one, calendar: calendar)

        index_url = responsible_calendar_activities_path(calendar)
        visit index_url

        expect(page).to have_link(activity.name,
                                  href: responsible_calendar_activity_path(calendar, activity))
        expect(page).to have_contents([activity.base_activity_type.name,
                                       I18n.t("enums.tcc.#{activity.tcc}"),
                                       activity.deadline])
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end

      it 'shows all activities for tcc two with options' do
        calendar = create(:current_calendar_tcc_two)
        activity = create(:activity_tcc_one, calendar: calendar)

        index_url = responsible_calendar_activities_path(calendar)
        visit index_url

        expect(page).to have_link(activity.name,
                                  href: responsible_calendar_activity_path(calendar, activity))
        expect(page).to have_contents([activity.base_activity_type.name,
                                       I18n.t("enums.tcc.#{activity.tcc}"),
                                       activity.deadline])
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end

    context 'when shows all activities selected by calendar' do
      it 'shows all activities selected by calendar' do
        calendar = create(:calendar_tcc_one, semester: 1)
        second_calendar = create(:calendar_tcc_one, semester: 2)
        activity = create(:activity_tcc_one, calendar: second_calendar)

        visit responsible_calendar_activities_path(calendar)
        selectize(second_calendar.year_with_semester, from: 'activity_calendar')

        expect(page).to have_contents([activity.name,
                                       activity.base_activity_type.name,
                                       I18n.t("enums.tcc.#{activity.tcc}"),
                                       activity.deadline])
      end
    end

    context 'when shows all activities by the next calendar' do
      it 'shows all activities by the next calendar' do
        calendar = create(:current_calendar_tcc_one, semester: 1)
        second_calendar = create(:current_calendar_tcc_one, semester: 2)
        activity = create(:activity_tcc_one, calendar: second_calendar)

        visit responsible_calendar_activities_path(calendar)
        find('#next_calendar').click

        expect(page).to have_contents([activity.name,
                                       activity.base_activity_type.name,
                                       I18n.t("enums.tcc.#{activity.tcc}"),
                                       activity.deadline])
      end
    end
  end
end
