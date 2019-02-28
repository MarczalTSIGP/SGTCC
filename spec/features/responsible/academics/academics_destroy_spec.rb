require 'rails_helper'

describe 'Academics::destroy', type: :feature do
  let(:professor) { create(:professor) }
  let(:resource_name) { Academic.model_name.human }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#destroy' do
    context 'with valid destroy', js: true do
      it 'academic' do
        academic = create(:academic)
        visit responsible_academics_path

        within first('.destroy').click

        alert = page.driver.browser.switch_to.alert
        alert.accept
        sleep 2.seconds
        expect_alert_success(resource_name, 'flash.actions.destroy.m')
        expect(page).not_to have_content(academic.name)
      end
    end
  end
end
