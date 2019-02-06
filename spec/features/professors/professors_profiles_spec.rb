require 'rails_helper'

describe 'Professors:Profiles', type: :feature do
  context 'when update a professor' do
    let(:professor) { create(:professor) }

    before do
      login_as(professor, scope: :professor)
      visit edit_professor_registration_path
    end

    it 'updates with success when the data are valid', js: true do
      new_email = 'email@email.com'

      fill_in 'professor_email', with: new_email
      attach_file 'professor_profile_image', FileSpecHelper.image.path
      fill_in 'professor_current_password', with: professor.password

      find('input[name="commit"]').click

      expect(page).to have_current_path edit_professor_registration_path
      expect(page).to have_selector('div.alert.alert-info',
                                    text: I18n.t('devise.registrations.updated'))

      within('a.nav-link') do
        expect(page).to have_content(new_email)
      end
    end

    it 'does not update with invalid date', js: true do
      fill_in 'professor_email', with: 'email'
      fill_in 'professor_current_password', with: professor.password

      attach_file 'professor_profile_image', FileSpecHelper.pdf.path

      find('input[name="commit"]').click

      expect(page).to have_selector('div.alert.alert-danger',
                                    text: I18n.t('simple_form.error_notification.default_message'))

      within('div.professor_email') do
        expect(page).to have_content(I18n.t('errors.messages.invalid'))
      end

      within('div.professor_current_password') do
        expect(page).to have_content(
          I18n.t('devise.registrations.edit.we_need_your_current_password_to_confirm_your_changes')
        )
      end

      within('div.professor_profile_image') do
        expect(page).to have_content(I18n.t('errors.messages.extension_whitelist_error',
                                            extension: '"pdf"',
                                            allowed_types: 'jpg, jpeg, gif, png'))
      end
    end
  end
end
