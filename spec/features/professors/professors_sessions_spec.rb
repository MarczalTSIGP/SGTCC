require 'rails_helper'

describe "Professors:Sessions", type: :feature do

	it "displays the professor's perfil links after successful login" do
		professor = create(:professor)

		visit new_professor_session_path

		fill_in 'professor_email', with: professor.email
		fill_in 'professor_password', with: 'password'

		submit_form

		expect(page.current_path).to eq professors_root_path

		expect(page).to have_selector(
			'div.alert.alert-info',
			text: I18n.t('devise.sessions.signed_in')
		)
	end

	it "displays the professor's error message when user or password is wrong" do
		professor = create(:professor)

		visit new_professor_session_path

		fill_in 'professor_email', with: professor.email
		fill_in 'professor_password', with: 'passworda'

		submit_form

		expect(page.current_path).to eq new_professor_session_path

		expect(page).to have_selector(
			'div.alert.alert-warning',
			text: I18n.t('devise.failure.invalid', authentication_keys: 'Email')
		)
	end

	it 'displays success logout message when the user click on logout' do
		professor = create(:professor)
		login_as(professor, scope: :professor)

		visit professors_root_url

		click_link professor.email
		click_link(I18n.t('sessions.sign_out'))

		expect(page.current_path).to eq new_professor_session_path

		expect(page).to have_selector(
			'div.alert.alert-info',
			text: I18n.t('devise.sessions.already_signed_out')
		)
	end
end
