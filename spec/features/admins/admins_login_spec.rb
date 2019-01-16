require 'rails_helper'

describe 'Admins:login', type: :feature do

  let(:admin) { create(:admin) }

  before(:each) do
    visit new_admin_session_path
  end

  it 'displays the admins perfil links on valid login' do
    fill_in 'admin_email', with: admin.email
    fill_in 'admin_password', with: 'password'

    submit_form

    expect(page.current_path).to eq admins_root_path

    expect(page).to have_selector(
      'div.alert.alert-info',
      text: I18n.t('devise.sessions.signed_in')
    )
  end

  it 'displays the admins error message when user or password is wrong' do
    fill_in 'admin_email', with: admin.email
    fill_in 'admin_password', with: 'passworda'

    submit_form

    expect(page.current_path).to eq new_admin_session_path

    expect(page).to have_selector(
      'div.alert.alert-warning',
      text: I18n.t('devise.failure.invalid', authentication_keys: 'Email')
    )
  end
end
