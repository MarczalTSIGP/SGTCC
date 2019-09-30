require 'rails_helper'

describe 'ExternalMember:profiles', type: :feature, js: true do
  context 'when update a external_member' do
    let(:external_member) { create(:external_member) }

    before do
      login_as(external_member, scope: :external_member)
      visit edit_external_member_registration_path
    end

    it 'updates with success when the data are valid' do
      attributes = attributes_for(:external_member)
      fill_in 'external_member_name', with: attributes[:name]
      fill_in 'external_member_email', with: attributes[:email]
      fill_in 'external_member_personal_page', with: attributes[:personal_page]
      attach_file 'external_member_profile_image', FileSpecHelper.image.path
      fill_in 'external_member_current_password', with: external_member.password
      submit_form('input[name="commit"]')

      expect(page).to have_current_path edit_external_member_registration_path
      expect(page).to have_flash(:info, text: registrations_updated_message)
      expect(page).to have_message(attributes[:name], in: 'a.nav-link')
      expect(page).to have_field 'external_member_name', with: attributes[:name]
      expect(page).to have_field 'external_member_email', with: attributes[:email]
      expect(page).to have_field 'external_member_personal_page', with: attributes[:personal_page]
    end

    it 'does not update with invalid date' do
      fill_in 'external_member_name', with: ''
      fill_in 'external_member_email', with: 'email'
      fill_in 'external_member_current_password', with: external_member.password
      attach_file 'external_member_profile_image', FileSpecHelper.pdf.path
      submit_form('input[name="commit"]')

      expect(page).to have_flash(:danger, text: default_error_message)
      expect(page).to have_message(blank_error_message, in: 'div.external_member_name')
      expect(page).to have_message(invalid_error_message, in: 'div.external_member_email')
      expect(page).to have_message(confirm_password_error_message,
                                   in: 'div.external_member_current_password')
      expect(page).to have_message(image_error_message,
                                   in: 'div.external_member_profile_image')
    end
  end
end
