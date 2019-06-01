require 'rails_helper'

describe 'Orientation::cancel', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:orientation) { create(:orientation) }
  let(:resource_name) { Orientation.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_orientation_path(orientation)
  end

  describe '#show', js: true do
    context 'when the orientation is cancelled' do
      it 'show success message and update the status' do
        find('button[id="orientation_cancel"]', text: orientation_cancel_button).click
        accept_alert
        flash_message = I18n.t('json.messages.orientation.cancel.success')
        expect(page).to have_flash(:success, text: flash_message)
      end
    end
  end
end
