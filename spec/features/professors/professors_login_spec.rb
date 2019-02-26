require 'rails_helper'

describe 'Professors:login', type: :feature do
  let(:professor) { create(:professor) }

  before do
    visit new_responsible_session_path
  end

  it 'displays the professors perfil links on valid login', js: true do
    fill_in 'professor_username', with: professor.username
    fill_in 'professor_password', with: 'password'

    submit_form('input[name="commit"]')

    expect(page).to have_current_path responsible_root_path
    expect(page).to have_flash(:info, text: I18n.t('devise.sessions.signed_in'))
  end

  it 'displays the professors error', js: true do
    fill_in 'professor_username', with: professor.username
    fill_in 'professor_password', with: 'passworda'

    submit_form('input[name="commit"]')

    expect(page).to have_current_path new_responsible_session_path

    resource_name = Professor.human_attribute_name(:username)
    expect(page).to have_flash(:warning,
                               text: I18n.t('devise.failure.invalid',
                                            authentication_keys: resource_name))
  end
end
