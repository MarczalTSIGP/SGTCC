require 'rails_helper'

describe 'Responsible:profiles', type: :feature, js: true do
  context 'when update a academic' do
    let(:academic) { create(:academic) }

    before do
      login_as(academic, scope: :academic)
      visit edit_academic_registration_path
    end

    it 'updates with success when the data are valid' do
      new_email = 'email@email.com'
      new_name = 'new name'

      fill_in 'academic_email', with: new_email
      fill_in 'academic_name', with: new_name

      attach_file 'academic_profile_image', FileSpecHelper.image.path
      fill_in 'academic_current_password', with: academic.password

      submit_form('input[name="commit"]')

      expect(page).to have_current_path edit_academic_registration_path
      expect(page).to have_flash(:info, text: registrations_updated_message)

      within('a.nav-link') do
        expect(page).to have_content(new_name)
      end

      expect(page).to have_field 'academic_name', with: new_name
      expect(page).to have_field 'academic_email', with: new_email
    end

    it 'does not update with invalid date' do
      fill_in 'academic_name', with: ''
      fill_in 'academic_email', with: 'email'
      fill_in 'academic_current_password', with: academic.password
      attach_file 'academic_profile_image', FileSpecHelper.pdf.path
      submit_form('input[name="commit"]')

      expect(page).to have_flash(:danger, text: default_error_message)
      expect(page).to have_message(blank_error_message, in: 'div.academic_name')
      expect(page).to have_message(invalid_error_message, in: 'div.academic_email')
      expect(page).to have_message(confirm_password_message, in: 'div.academic_current_password')
      expect(page).to have_message(profile_image_error_message, in: 'div.academic_profile_image')
    end
  end
end
