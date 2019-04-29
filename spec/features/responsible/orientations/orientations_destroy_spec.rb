require 'rails_helper'

describe 'Orientation::destroy', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:orientation) { create(:orientation) }
  let(:resource_name) { Orientation.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_orientations_path
  end

  describe '#destroy' do
    context 'when orientation is destroyed', js: true do
      it 'show the success message' do
        within first('.destroy').click
        alert = page.driver.browser.switch_to.alert
        alert.accept
        sleep 2.seconds

        success_message = I18n.t('flash.actions.destroy.f', resource_name: resource_name)
        expect(page).to have_flash(:success, text: success_message)
        expect(page).not_to have_content(orientation.title)
      end
    end
  end
end
