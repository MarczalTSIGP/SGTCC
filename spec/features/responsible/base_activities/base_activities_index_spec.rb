require 'rails_helper'

describe 'BaseActivity::index', type: :feature do
  describe '#index' do
    context 'when shows all base activities with tcc 1' do
      it 'shows all base activities with tcc 1 options', js: true do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        base_activities = create_list(:base_activity_tcc_one, 3)

        visit responsible_base_activities_tcc_one_path

        base_activities.each do |base_activity|
          expect(page).to have_contents([base_activity.name,
                                         base_activity.base_activity_type.name,
                                         short_date(base_activity.created_at)])
        end
      end
    end

    context 'when shows all base activities with tcc 2' do
      it 'shows all base activities with tcc 2 options', js: true do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        base_activities = create_list(:base_activity_tcc_two, 3)

        visit responsible_base_activities_tcc_two_path

        base_activities.each do |base_activity|
          expect(page).to have_contents([base_activity.name,
                                         base_activity.base_activity_type.name,
                                         short_date(base_activity.created_at)])
        end
      end
    end
  end
end