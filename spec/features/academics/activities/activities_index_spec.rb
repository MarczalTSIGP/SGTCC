require 'rails_helper'

describe 'Activity::index', type: :feature, js: true do
  let(:academic) { create(:academic) }

  describe '#index' do
    before do
      login_as(academic, scope: :academic)
    end

    context 'when shows all activities' do
      it 'shows all activities for tcc one with options' do
        calendar = create(:current_calendar_tcc_one)
        activity = create(:activity_tcc_one, calendar: calendar)
        create(:orientation, calendar: calendar, academic: academic)

        index_url = academics_calendar_activities_path(calendar)
        visit index_url

        expect(page).to have_contents([activity.name,
                                       activity.base_activity_type.name,
                                       I18n.t("enums.tcc.#{activity.tcc}"),
                                       activity.deadline])
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end

      it 'shows all activities for tcc two with options' do
        calendar = create(:current_calendar_tcc_two)
        activity = create(:activity_tcc_one, calendar: calendar)
        create(:orientation, calendar: calendar, academic: academic)

        index_url = academics_calendar_activities_path(calendar)
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
