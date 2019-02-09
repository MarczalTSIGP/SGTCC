require 'rails_helper'

describe 'Professors:login', type: :feature do
  let(:professor) { create(:professor) }

  before do
    visit new_professor_session_path
  end

  it 'displays the professors perfil links on valid login' do
    fill_in 'professor_email', with: professor.email
    fill_in 'professor_password', with: 'password'

    submit_form

    expect(page).to have_current_path professors_root_path

    expect(page).to have_selector(
      'div.alert.alert-info',
      text: I18n.t('devise.sessions.signed_in')
    )
  end

  it 'displays the professors error message when user or password is wrong' do
    fill_in 'professor_email', with: professor.email
    fill_in 'professor_password', with: 'passworda'

    submit_form

    expect(page).to have_current_path new_professor_session_path

    expect(page).to have_selector(
      'div.alert.alert-warning',
      text: I18n.t('devise.failure.invalid', authentication_keys: 'Email')
    )
  end
end
