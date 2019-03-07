require 'rails_helper'

describe 'Responsible:profiles', type: :feature do
  context 'when updates the responsible' do
    let(:professor) { create(:professor) }

    before do
      login_as(professor, scope: :professor)
      visit edit_responsible_registration_path
    end

    context 'when data is valid' do
      it 'updates responsible', js: true do
        new_email = 'email@email.com'
        new_name = 'new name'

        fill_in 'professor_email', with: new_email
        fill_in 'professor_name', with: new_name
        fill_in 'professor_lattes', with: professor.lattes

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
    end

    context 'when data is not valid' do
      it 'does not update', js: true do
        fill_in 'professor_name', with: ''
        fill_in 'professor_email', with: 'email'
        fill_in 'professor_current_password', with: professor.password
        attach_file 'professor_profile_image', FileSpecHelper.pdf.path
        submit_form('input[name="commit"]')

        notification_message = I18n.t('simple_form.error_notification.default_message')
        expect(page).to have_flash(:danger, text: notification_message)

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
end
