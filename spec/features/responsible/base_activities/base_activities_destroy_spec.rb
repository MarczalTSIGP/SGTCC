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
      it 'show success message' do
        click_on_destroy_link(responsible_base_activity_path(base_activity))
        accept_alert
        expect(page).to have_flash(:success, text: message('destroy.f'))
        expect(page).to have_no_content(base_activity.name)
      end
    end
  end
end
