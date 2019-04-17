require 'rails_helper'

describe 'Activity::index', type: :feature do
  describe '#index' do
    context 'when shows all activities with tcc 1' do
      it 'shows all activities with tcc 1 options', js: true do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        activities = create_list(:activity_tcc_one, 3)

        visit responsible_activities_tcc_one_path

        activities.each do |activity|
          expect(page).to have_contents([activity.name,
                                         activity.base_activity_type.name,
                                         short_date(activity.created_at)])
        end
      end
    end

    context 'when shows all activities with tcc 2' do
      it 'shows all activities with tcc 2 options', js: true do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        activities = create_list(:activity_tcc_two, 3)

        visit responsible_activities_tcc_two_path

        activities.each do |activity|
          expect(page).to have_contents([activity.name,
                                         activity.base_activity_type.name,
                                         short_date(activity.created_at)])
        end
      end
    end
  end
end
