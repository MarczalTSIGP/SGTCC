require 'rails_helper'

describe 'Activity::index', type: :feature, js: true do
  let!(:calendar_tcc_one) { create(:current_calendar_tcc_one) }
  let!(:activity) { create(:activity_tcc_one, calendar: calendar_tcc_one) }

  describe '#index' do
    before do
      professor = create(:professor_tcc_one)
      login_as(professor, scope: :professor)
    end

    context 'when shows all activities' do
      it 'shows all activities for tcc one with options' do
        index_url = professors_calendar_activities_path(calendar_tcc_one)
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
