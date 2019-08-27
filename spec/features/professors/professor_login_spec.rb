require 'rails_helper'

describe 'Professors:login', type: :feature, js: true do
  let(:professor) { create(:professor) }
  let(:resource_name) { Professor.human_attribute_name(:username) }

  before do
    visit new_professor_session_path
  end

  context 'when login is valid' do
    it 'show success message' do
      fill_in 'professor_username', with: professor.username
      fill_in 'professor_password', with: 'password'

      submit_form('input[name="commit"]')

      expect(page).to have_current_path professors_root_path
      expect(page).to have_flash(:info, text: signed_in_message)
    end
  end

  context 'when login is not valid' do
    it 'show errors messages' do
      fill_in 'professor_username', with: professor.username
      fill_in 'professor_password', with: 'passworda'

      submit_form('input[name="commit"]')

      expect(page).to have_current_path new_professor_session_path
      expect(page).to have_flash(:warning, text: invalid_sign_in_message)
    end
  end

  context 'when professor is not authorized' do
    before do
      login_as(professor, scope: :professor)
      visit responsible_academics_path
    end

    it 'redirect to the professors page' do
      expect(page).to have_current_path professors_root_path
      expect(page).to have_flash(:warning, text: not_authorized_message)
    end
  end

  context 'when professor is not authenticated' do
    before do
      visit professors_root_path
    end

    it 'redirect to the login page' do
      expect(page).to have_current_path new_professor_session_path
      expect(page).to have_flash(:warning, text: unauthenticated_message)
    end
  end
end
