require 'rails_helper'

describe 'Professors:Profiles', type: :feature do
  context 'when update a professor' do
    let(:professor) { create(:professor) }

    before do
      login_as(professor, scope: :professor)
      visit edit_responsible_registration_path
    end

    it 'updates with success when the data are valid', js: true do
      new_email = 'email@email.com'
      new_name = 'new name'

      fill_in 'professor_email', with: new_email
      fill_in 'professor_name', with: new_name

      attach_file 'professor_profile_image', FileSpecHelper.image.path
      fill_in 'professor_current_password', with: professor.password

      submit_form('input[name="commit"]')

      expect(page).to have_current_path edit_responsible_registration_path
      expect(page).to have_flash(:info, text: I18n.t('devise.registrations.updated'))

      within('a.nav-link') do
        expect(page).to have_content(new_name)
      end

      expect(page).to have_field 'professor_name', with: new_name
      expect(page).to have_field 'professor_email', with: new_email
    end

    it 'does not update with invalid date', js: true do
      fill_in 'professor_name', with: ''
      fill_in 'professor_email', with: 'email'
      fill_in 'professor_current_password', with: professor.password
      attach_file 'professor_profile_image', FileSpecHelper.pdf.path
      submit_form('input[name="commit"]')

      expect(page).to have_flash(:danger,
                                 text: I18n.t('simple_form.error_notification.default_message'))

      expect(page).to have_message(I18n.t('errors.messages.blank'), in: 'div.professor_name')
      expect(page).to have_message(I18n.t('errors.messages.invalid'), in: 'div.professor_email')
      expect(page).to have_message(
        I18n.t('devise.registrations.edit.we_need_your_current_password_to_confirm_your_changes'),
        in: 'div.professor_current_password'
      )

      expect(page).to have_message(I18n.t('errors.messages.extension_whitelist_error',
                                          extension: '"pdf"',
                                          allowed_types: 'jpg, jpeg, gif, png'),
                                   in: 'div.professor_profile_image')
    end
  end
end
