require 'rails_helper'

describe 'BaseActivity::index', type: :feature do
  describe '#index' do
    context 'when shows all base activities' do
      it 'shows all base activities with options', js: true do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        base_activities = create_list(:base_activity, 3)

        visit responsible_base_activities_path

        base_activities.each do |base_activity|
          expect(page).to have_contents([base_activity.name,
                                         base_activity.base_activity_type.name,
                                         base_activity.created_at.strftime('%d/%m/%Y')])
        end
      end
    end
  end
end
