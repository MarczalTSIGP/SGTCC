require 'rails_helper'

describe 'Orientation::abandon', type: :feature, js: true do
  let(:orientation) { create(:orientation) }
  let(:professor) { orientation.advisor }
  let(:resource_name) { Orientation.model_name.human }

  before do
    create(:document_tdo)
    create(:responsible)
    login_as(professor, scope: :professor)
    visit professors_orientation_path(orientation)
  end

  describe '#show' do
    context 'when the orientation is abandoned' do
      it 'shows success message and update the status' do
        find('button[id="orientation_abandon"]', text: orientation_abandon_button).click
        accept_alert
        fill_in 'orientation_abandon_justification', with: 'Justification'
        find('button[id="save_justification"]', text: save_button).click
        flash_message = I18n.t('json.messages.orientation.abandon.success')
        expect(page).to have_flash(:success, text: flash_message)
        orientation.reload
        expect(page).to have_content(orientation.status)
      end
    end

    context 'when the abandonment is invalid' do
      it 'shows blank error message' do
        find('button[id="orientation_abandon"]', text: orientation_abandon_button).click
        accept_alert
        find('button[id="save_justification"]', text: save_button).click
        expect(page).to have_message(blank_error_message,
                                     in: 'div.orientation_abandon_justification')
      end
    end
  end
end
