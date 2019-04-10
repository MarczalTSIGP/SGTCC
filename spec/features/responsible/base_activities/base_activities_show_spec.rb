require 'rails_helper'

describe 'BaseActivities::show', type: :feature do
  describe '#show' do
    context 'when shows the base activity' do
      it 'shows the base activity' do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        base_activity = create(:base_activity_tcc_one)
        visit responsible_base_activity_path(base_activity)

        expect(page).to have_contents([base_activity.name,
                                       base_activity.base_activity_type.name,
                                       complete_date(base_activity.created_at),
                                       complete_date(base_activity.updated_at)])
      end
    end
  end
end
