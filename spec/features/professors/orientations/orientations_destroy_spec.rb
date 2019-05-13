require 'rails_helper'

describe 'Orientation::destroy', type: :feature do
  let(:orientation) { create(:current_orientation_tcc_one) }
  let(:resource_name) { Orientation.model_name.human }

  before do
    login_as(orientation.advisor, scope: :professor)
    visit professors_orientations_tcc_one_path
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
        expect(page).not_to have_content(orientation.short_title)
      end
    end
  end
end
