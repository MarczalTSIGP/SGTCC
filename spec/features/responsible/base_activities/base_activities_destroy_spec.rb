require 'rails_helper'

describe 'BaseActivity::destroy', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { BaseActivity.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#destroy' do
    context 'when base activity is destroyed', js: true do
      it 'show success message' do
        base_activity = create(:base_activity_tcc_one)
        visit responsible_base_activities_path

        within first('.destroy').click

        alert = page.driver.browser.switch_to.alert
        alert.accept
        sleep 2.seconds

        success_message = I18n.t('flash.actions.destroy.f', resource_name: resource_name)
        expect(page).to have_flash(:success, text: success_message)

        expect(page).not_to have_content(base_activity.name)
      end
    end
  end
end
