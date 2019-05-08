require 'rails_helper'

describe 'BaseActivity::destroy', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:base_activity) { create(:base_activity_tcc_one) }
  let(:resource_name) { BaseActivity.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_base_activities_tcc_one_path
  end

  describe '#destroy' do
    context 'when base activity is destroyed', js: true do
      it 'show success message' do
        within first('.destroy').click
        accept_alert
        expect(page).to have_flash(:success, text: success_message('destroy.f', resource_name))
        expect(page).not_to have_content(base_activity.name)
      end
    end
  end
end
