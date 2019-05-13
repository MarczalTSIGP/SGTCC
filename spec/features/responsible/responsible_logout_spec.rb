require 'rails_helper'

describe 'Responsible:logout', type: :feature, js: true do
  let(:professor) { create(:responsible) }

  before do
    login_as(professor, scope: :professor)
    visit responsible_academics_path
  end

  context 'when responsible logout' do
    it 'show success message' do
      click_link professor.name
      click_link(sign_out_button)

      expect(page).to have_current_path new_professor_session_path
      expect(page).to have_flash(:info, text: already_signed_out_message)
    end
  end
end
