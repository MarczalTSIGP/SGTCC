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
        create(:academic)
        visit responsible_academics_path

        within first('.destroy').click

        alert = page.driver.browser.switch_to.alert
        sleep 2.seconds
        expect { alert.accept }.to change(Academic, :count).by(0)
        expect_alert_success(resource_name, 'flash.actions.destroy.m')
      end
    end
  end
end
