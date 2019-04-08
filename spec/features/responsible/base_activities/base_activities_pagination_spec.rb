require 'rails_helper'

describe 'BaseActivity::pagination', type: :feature do
  describe '#pagination' do
    context 'when finds the last base activity on second page' do
      it 'finds the last base activity', js: true do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        create_list(:base_activity, 30)
        visit responsible_base_activities_path
        base_activity = BaseActivity.order(:name).last

        click_link(2)

        expect(page).to have_contents([base_activity.name,
                                       base_activity.base_activity_type.name,
                                       short_date(base_activity.created_at)])
      end
    end
  end
end
