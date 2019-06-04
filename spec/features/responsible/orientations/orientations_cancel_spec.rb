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
      it 'shows success message and update the status' do
        find('button[id="orientation_cancel"]', text: orientation_cancel_button).click
        fill_in 'orientation_cancel_justification', with: 'Justification'
        find('button[id="save_justification"]', text: save_button).click
        flash_message = I18n.t('json.messages.orientation.cancel.success')
        expect(page).to have_flash(:success, text: flash_message)
        orientation.reload
        expect(page).to have_content(orientation.status)
      end
    end

    context 'when the cancellation is invalid' do
      it 'shows blank error message' do
        find('button[id="orientation_cancel"]', text: orientation_cancel_button).click
        find('button[id="save_justification"]', text: save_button).click
        expect(page).to have_message(blank_error_message,
                                     in: 'div.orientation_cancel_justification')
      end
    end
  end
end
