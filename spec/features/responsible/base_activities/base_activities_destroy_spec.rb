require 'rails_helper'

describe 'BaseActivity::destroy', :js do
  let(:responsible) { create(:responsible) }
  let!(:base_activity) { create(:base_activity_tcc_one) }
  let(:resource_name) { BaseActivity.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_base_activities_tcc_one_path
  end

  describe '#destroy' do
    context 'when base activity is destroyed' do
      let(:destroy_path) { responsible_base_activity_path(base_activity) }
      let(:destroyed_record_name) { base_activity.name }

      it_behaves_like 'responsible destroy success flow', message_key: 'destroy.f'
    end
  end
end
