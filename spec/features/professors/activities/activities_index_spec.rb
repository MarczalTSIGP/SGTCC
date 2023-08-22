require 'rails_helper'

describe 'Activity::index', type: :feature do
  let!(:calendar_tcc_one) { create(:current_calendar_tcc_one) }
  let!(:calendar_tcc_two) { create(:current_calendar_tcc_two) }

  describe '#index' do
    before do
      professor = create(:professor)
      login_as(professor, scope: :professor)
    end

    context 'when shows all activities' do
      it 'shows all activities for tcc one with options', js: true do
        activity = create(:activity_tcc_one, calendar: calendar_tcc_one)

        index_url = professors_calendar_activities_path(calendar_tcc_one)
        visit index_url

        expect(page).to have_link(activity.name,
                                  href: professors_calendar_activity_path(calendar_tcc_one,
                                                                          activity))
        expect(page).to have_contents([activity.base_activity_type.name,
                                       activity.deadline])

        expect(page).to have_selector("a[href='#{index_url}'].active")
      end

      it 'shows all activities for tcc two with options', js: true do
        activity = create(:activity_tcc_two, calendar: calendar_tcc_two)

        index_url = professors_calendar_activities_path(calendar_tcc_two)
        visit index_url

        expect(page).to have_link(activity.name,
                                  href: professors_calendar_activity_path(calendar_tcc_two,
                                                                          activity))
        expect(page).to have_contents([activity.base_activity_type.name,
                                       activity.deadline])
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end
