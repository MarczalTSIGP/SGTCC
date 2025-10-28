require 'rails_helper'

describe 'Orientation::cancel' do
  let(:responsible) { create(:responsible) }
  let(:orientation) { create(:orientation) }
  let(:resource_name) { Orientation.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_orientation_path(orientation)
  end

  describe '#show', :js do
    context 'when the orientation is cancelled' do
      it 'shows success message and update the status' do
        click_button(orientation_cancel_button, id: 'orientation_cancel')
        fill_in 'orientation_cancel_justification', with: 'Justification'
        click_button(save_button, id: 'save_justification')
        
        expect(page).to have_current_path responsible_orientation_path(orientation)
        flash_message = I18n.t('json.messages.orientation.cancel.success')
        expect(page).to have_flash(:success, text: flash_message)
        orientation.reload
        expect(page).to have_content(orientation.status)
      end
    end

    context 'when the cancellation is invalid' do
      it 'shows blank error message' do
        click_button(orientation_cancel_button, id: 'orientation_cancel')
        click_button(save_button, id: 'save_justification')
        
        flash_message = I18n.t('json.messages.empty_fields')
        expect(page).to have_flash(:danger, text: flash_message)
      end
    end
  end
end
