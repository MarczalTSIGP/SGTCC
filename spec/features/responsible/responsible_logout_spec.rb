require 'rails_helper'

describe 'Responsible:logout', type: :feature do
  let(:professor) { create(:responsible) }

  before do
    login_as(professor, scope: :professor)
    visit responsible_academics_path
  end

  context 'when responsible logout' do
    it 'show success message', js: true do
      click_link professor.name
      click_link(I18n.t('sessions.sign_out'))

      expect(page).to have_current_path new_professor_session_path

      info_message = I18n.t('devise.sessions.already_signed_out')
      expect(page).to have_flash(:info, text: info_message)
    end
  end
end
