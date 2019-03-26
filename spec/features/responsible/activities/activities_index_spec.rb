require 'rails_helper'

describe 'Activity::index', type: :feature do
  describe '#index' do
    context 'when shows all activities' do
      it 'shows all activities with options', js: true do
        responsible = create(:professor)
        login_as(responsible, scope: :professor)

        activities = create_list(:activity, 3)

        visit responsible_activities_path

        activities.each do |a|
          expect(page).to have_contents([a.name,
                                         a.activity_type.name,
                                         a.created_at.strftime('%d/%m/%Y')])
        end
      end
    end
  end
end
