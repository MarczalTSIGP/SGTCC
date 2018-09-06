require 'rails_helper'

describe "Users:Profiles", type: :feature do
	context "Update a user" do
		it 'should update a user with success when the data are valid' do
			user = create(:user)
			login_as(user, scope: :user)

			visit edit_professor_registration_path

			fill_in User.human_attribute_name(:email), with: 'email@email.com'
			fill_in I18n.t('simple_form.labels.defaults.current_password'), with: user.password

			find('input[name="commit"]').click

			expect(page.current_path).to eq edit_professor_registration_path
			expect(page).to have_selector('div.alert.alert-info',
																		text:  I18n.t("devise.registrations.updated"))
		end

		it 'should not update a user with invalid date, and must show a error message' do
			user = create(:user)
			login_as(user, scope: :user)

			visit edit_professor_registration_path

			fill_in User.human_attribute_name(:email), with: 'email'
			fill_in User.human_attribute_name(:password), with: 'abc123'
			fill_in User.human_attribute_name(:password_confirmation), with: 'abc123'
			fill_in I18n.t('simple_form.labels.defaults.current_password'), with: user.password

			expect do
				find('input[name="commit"]').click
			end.to change(User, :count).by(0)

			expect(page).to have_selector('div.alert.alert-danger',
																		text: I18n.t("simple_form.error_notification.default_message"))

			within('div.user_email') do
				expect(page).to have_content(I18n.t('errors.messages.invalid'))
			end

			within('div.user_current_password') do
				expect(page).to have_content(
					I18n.t('devise.registrations.edit.we_need_your_current_password_to_confirm_your_changes')
				)
			end
		end
	end
end

