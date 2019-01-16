require 'spec_helper'

describe "Admins:Profiles", type: :feature do
	context "Update a admin" do
		it 'should update a admin with success when the data are valid' do
			admin = create(:admin)
			login_as(admin, scope: :admin)

			visit edit_admin_registration_path

			fill_in Admin.human_attribute_name(:email), with: 'email@email.com'
			fill_in I18n.t('simple_form.labels.defaults.current_password'), with: admin.password

			submit_form

			expect(page.current_path).to eq edit_admin_registration_path
			expect(page).to have_selector('div.alert.alert-info',
																		text:  I18n.t("devise.registrations.updated"))
		end

		it 'should not update a admin with invalid date, and must show a error message' do
			admin = create(:admin)
			login_as(admin, scope: :admin)

			visit edit_admin_registration_path

			fill_in Admin.human_attribute_name(:email), with: 'email'
			fill_in Admin.human_attribute_name(:password), with: 'abc123'
			fill_in Admin.human_attribute_name(:password_confirmation), with: 'abc123'
			fill_in I18n.t('simple_form.labels.defaults.current_password'), with: admin.password

			expect do
				submit_form
			end.to change(Admin, :count).by(0)

			expect(page).to have_selector('div.alert.alert-danger',
																		text: I18n.t("simple_form.error_notification.default_message"))

			within('div.admin_email') do
				expect(page).to have_content(I18n.t('errors.messages.invalid'))
			end

			within('div.admin_current_password') do
				expect(page).to have_content(
					I18n.t('devise.registrations.edit.we_need_your_current_password_to_confirm_your_changes')
				)
			end
		end
	end
end

