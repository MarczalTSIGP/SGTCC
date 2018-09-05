require 'rails_helper'

describe "Users:Sessions", type: :feature do

  it "displays the user's perfil links after successful login" do
    user = create(:user)

    visit new_user_session_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'

    find('input[name="commit"]').click

    expect(page.current_path).to eq root_path

    expect(page).to have_selector(
      'div.alert.alert-info',
      text: I18n.t('devise.sessions.signed_in')
    )
  end

  it "displays the user's error message when user or password is wrong" do
    user = create(:user)

    visit new_user_session_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'passworda'

    find('input[name="commit"]').click

    expect(page.current_path).to eq new_user_session_path

    expect(page).to have_selector(
      'div.alert.alert-warning',
      text: I18n.t('devise.failure.invalid', authentication_keys: 'Email')
    )
  end

  it 'displays success logout message when the user click on logout' do
    user = create(:user)
    login_as(user, scope: :user)

    visit root_url

    click_link user.email
    click_link(I18n.t('sessions.sign_out'))

    expect(page.current_path).to eq new_user_session_path

    expect(page).to have_selector(
      'div.alert.alert-info',
      text: I18n.t('devise.sessions.already_signed_out')
    )
  end
end
