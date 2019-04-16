require 'rails_helper'

describe 'Academic::destroy', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Academic.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#destroy' do
    context 'when academic is destroyed', js: true do
      it 'show success message' do
        academic = create(:academic)
        visit responsible_academics_path

        within first('.destroy').click

        alert = page.driver.browser.switch_to.alert
        alert.accept
        sleep 2.seconds

        success_message = I18n.t('flash.actions.destroy.m', resource_name: resource_name)
        expect(page).to have_flash(:success, text: success_message)

        expect(page).not_to have_content(academic.name)
      end
    end
  end
end
