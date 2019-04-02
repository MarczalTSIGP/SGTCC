require 'rails_helper'

describe 'Activities::show', type: :feature do
  describe '#show' do
    context 'when shows the activity' do
      it 'shows the activity' do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        activity = create(:activity)
        visit responsible_activity_path(activity)

        expect(page).to have_contents([activity.name,
                                       activity.activity_type.name,
                                       complete_date(activity.created_at),
                                       complete_date(activity.updated_at)])
      end
    end
  end
end
