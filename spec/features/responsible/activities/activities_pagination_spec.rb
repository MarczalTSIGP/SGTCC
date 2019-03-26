require 'rails_helper'

describe 'Activity::pagination', type: :feature do
  describe '#pagination' do
    context 'when finds the last activity on second page' do
      it 'finds the last activity', js: true do
        responsible = create(:professor)
        login_as(responsible, scope: :professor)

        create_list(:activity, 30)
        visit responsible_activities_path
        activity = Activity.order(:name).last

        click_link(2)

        expect(page).to have_contents([activity.name,
                                       activity.activity_type.name,
                                       activity.created_at.strftime('%d/%m/%Y')])
      end
    end
  end
end
