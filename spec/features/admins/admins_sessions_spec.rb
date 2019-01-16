require 'rails_helper'

describe "Admins:Sessions", type: :feature do

	it "displays the admins's perfil links after successful login" do
		admin = create(:admin)

		visit new_admin_session_path

		fill_in 'admin_email', with: admin.email
		fill_in 'admin_password', with: 'password'

		submit_form

		expect(page.current_path).to eq admins_root_path

		expect(page).to have_selector(
			'div.alert.alert-info',
			text: I18n.t('devise.sessions.signed_in')
		)
	end

	it "displays the admin's error message when user or password is wrong" do
		admin = create(:admin)

		visit new_admin_session_path

		fill_in 'admin_email', with: admin.email
		fill_in 'admin_password', with: 'passworda'

		submit_form

		expect(page.current_path).to eq new_admin_session_path

		expect(page).to have_selector(
			'div.alert.alert-warning',
			text: I18n.t('devise.failure.invalid', authentication_keys: 'Email')
		)
	end

	it 'displays success logout message when the user click on logout' do
		admin = create(:admin)
		login_as(admin, scope: :admin)

		visit admins_root_url

		click_link admin.email
		click_link(I18n.t('sessions.sign_out'))

		expect(page.current_path).to eq new_admin_session_path

		expect(page).to have_selector(
			'div.alert.alert-info',
			text: I18n.t('devise.sessions.already_signed_out')
		)
	end
end
