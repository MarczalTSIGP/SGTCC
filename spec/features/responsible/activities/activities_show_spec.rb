require 'rails_helper'

describe 'Activity::show', type: :feature do
  describe '#show' do
    context 'when shows the activity' do
      it 'shows the activity' do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        activity = create(:activity_tcc_one)
        visit responsible_activity_path(activity)

        expect(page).to have_contents([activity.name,
                                       activity.base_activity_type.name,
                                       complete_date(activity.created_at),
                                       complete_date(activity.updated_at)])
      end
    end
  end
end
