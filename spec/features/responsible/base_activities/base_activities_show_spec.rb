require 'rails_helper'

describe 'BaseActivities::show', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:base_activity) { create(:base_activity_tcc_one) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_base_activity_path(base_activity)
  end

  describe '#show' do
    context 'when shows the base activity' do
      it 'shows the base activity' do
        expect(page).to have_contents([base_activity.name,
                                       base_activity.base_activity_type.name,
                                       complete_date(base_activity.created_at),
                                       complete_date(base_activity.updated_at)])
      end
    end
  end
end
