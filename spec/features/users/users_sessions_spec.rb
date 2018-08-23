require 'rails_helper'

describe "Users:Sessions", type: :feature do

  it "displays the user's perfil links after successful login" do
    user = create(:user)

    visit new_user_session_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'

    click_button I18n.t('sessions.sign_in')

    click_link 'Renan Gabriel'

    expect(page.current_path).to eq root_path
    expect(page).to have_selector('div.alert.alert-info',
                                  text: I18n.t('devise.registrations.signed_up'))
  end

  it "displays the user's error message when user or password is wrong" do
    user = create(:user)

    visit new_user_session_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'passworda'

    click_button I18n.t('sessions.sign_in')

    expect(page.current_path).to eq new_user_session_path
    expect(page).to have_selector('div.alert.alert-warning',
                                  text: I18n.t('devise.failure.invalid'))
  end

  it 'displays success logout message when the user click on logout' do
    user = create(:user)
    login_as(user, scope: :user)

    visit root_url

    click_link 'Renan Gabriel'
    click_link('Sair')

    expect(page.current_path).to eq new_user_session_path
    expect(page).to have_selector('div.alert.alert-info',
                                  text: 'Saiu com sucesso.')
  end

  context 'Register a user' do
    it 'should register a user with success when the data are valid' do
      user = build(:user)

      visit new_user_registration_path

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      fill_in 'user_password_confirmation', with: user.password

      expect do
        find('input[name="commit"]').click
      end.to change(User, :count).by(1)

      expect(page.current_path).to eq root_path
      expect(page).to have_selector('div.alert.alert-info',
                                    text: I18n.t('devise.registrations.signed_up'))
    end

    it 'should not register a user with invalid date, and must show a error message' do
      visit new_user_registration_path

      fill_in 'user_email', with: 'email'
      fill_in 'user_password', with: 'abc12'
      fill_in 'user_password_confirmation', with: '12314'

      expect do
        find('input[name="commit"]').click
      end.to change(User, :count).by(0)

      expect(page).to have_selector('div.alert.alert-danger',
                                    text: 'Alguns erros foram encontrados, por favor verifique:')

      within('div.user_email') do
        expect(page).to have_content('é inválido')
      end

      within('div.user_password') do
        expect(page).to have_content('mínimo: 6 caracteres')
      end

      within('div.user_password_confirmation') do
        expect(page).to have_content('não é igual a Senha')
      end
    end

  end
end
