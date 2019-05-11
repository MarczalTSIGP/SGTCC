require 'rails_helper'

describe 'ExternalMember:profiles', type: :feature, js: true do
  context 'when update a external_member' do
    let(:external_member) { create(:external_member) }

    before do
      login_as(external_member, scope: :external_member)
      visit edit_external_member_registration_path
    end

    it 'updates with success when the data are valid' do
      new_email = 'email@email.com'
      new_name = 'new name'

      fill_in 'external_member_email', with: new_email
      fill_in 'external_member_name', with: new_name

      attach_file 'external_member_profile_image', FileSpecHelper.image.path
      fill_in 'external_member_current_password', with: external_member.password

      submit_form('input[name="commit"]')

      expect(page).to have_current_path edit_external_member_registration_path
      expect(page).to have_flash(:info, text: I18n.t('devise.registrations.updated'))
      expect(page).to have_message(new_name, in: 'a.nav-link')
      expect(page).to have_field 'external_member_name', with: new_name
      expect(page).to have_field 'external_member_email', with: new_email
    end

    it 'does not update with invalid date' do
      fill_in 'external_member_name', with: ''
      fill_in 'external_member_email', with: 'email'
      fill_in 'external_member_current_password', with: external_member.password
      attach_file 'external_member_profile_image', FileSpecHelper.pdf.path
      submit_form('input[name="commit"]')

      error_message = I18n.t('simple_form.error_notification.default_message')
      expect(page).to have_flash(:danger, text: error_message)

      expect(page).to have_message(I18n.t('errors.messages.blank'), in: 'div.external_member_name')
      expect(page).to have_message(
        I18n.t('errors.messages.invalid'), in: 'div.external_member_email'
      )
      expect(page).to have_message(
        I18n.t('devise.registrations.edit.we_need_your_current_password_to_confirm_your_changes'),
        in: 'div.external_member_current_password'
      )
      expect(page).to have_message(I18n.t('errors.messages.extension_whitelist_error',
                                          extension: '"pdf"',
                                          allowed_types: 'jpg, jpeg, gif, png'),
                                   in: 'div.external_member_profile_image')
    end
  end
end
