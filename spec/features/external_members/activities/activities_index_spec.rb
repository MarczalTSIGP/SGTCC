require 'rails_helper'

describe 'Activity::index', :js do
  let(:external_member) { create(:external_member) }

  describe '#index' do
    before do
      login_as(external_member, scope: :external_member)
    end

    context 'when shows all activities' do
      it 'shows all activities for tcc one with options' do
        calendar = create(:current_calendar_tcc_one)
        activity = create(:activity_tcc_one, calendar: calendar)

        orientation = create(:orientation, calendars: [calendar])
        orientation.external_member_supervisors << external_member

        index_url = external_members_calendar_activities_path(calendar)
        visit index_url

        expect(page).to have_link(activity.name,
                                  href: external_members_calendar_activity_path(calendar, activity))
        expect(page).to have_contents([activity.base_activity_type.name,
                                       I18n.t("enums.tcc.#{activity.tcc}"),
                                       activity.deadline])
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end

      it 'shows all activities for tcc two with options' do
        calendar = create(:current_calendar_tcc_two)
        activity = create(:activity_tcc_two, calendar: calendar)
        orientation = create(:orientation, calendars: [calendar])
        orientation.external_member_supervisors << external_member

        index_url = external_members_calendar_activities_path(calendar)
        visit index_url

        expect(page).to have_contents([activity.name,
                                       activity.base_activity_type.name,
                                       I18n.t("enums.tcc.#{activity.tcc}"),
                                       activity.deadline])
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end
