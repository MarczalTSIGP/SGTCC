require 'rails_helper'

describe 'Responsible:profiles', type: :feature, js: true do
  context 'when updates the responsible' do
    let(:professor) { create(:responsible) }

    before do
      login_as(professor, scope: :professor)
      visit edit_professor_registration_path
    end

    context 'when data is valid' do
      it 'updates responsible' do
        attributes = attributes_for(:professor)

        fill_in 'professor_name', with: attributes[:name]
        fill_in 'professor_email', with: attributes[:email]
        fill_in 'professor_lattes', with: attributes[:lattes]

        attach_file 'professor_profile_image', FileSpecHelper.image.path
        fill_in 'professor_current_password', with: professor.password

        submit_form('input[name="commit"]')

        expect(page).to have_current_path edit_professor_registration_path
        expect(page).to have_flash(:info, text: registrations_updated_message)

        within('a.nav-link') do
          expect(page).to have_content(attributes[:name])
        end
        expect(page).to have_field 'professor_name', with: attributes[:name]
        expect(page).to have_field 'professor_email', with: attributes[:email]
        expect(page).to have_field 'professor_lattes', with: attributes[:lattes]
      end
    end

    context 'when data is not valid' do
      it 'does not update' do
        fill_in 'professor_name', with: ''
        fill_in 'professor_email', with: 'email'
        fill_in 'professor_lattes', with: ''
        fill_in 'professor_current_password', with: professor.password
        attach_file 'professor_profile_image', FileSpecHelper.pdf.path
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: default_error_message)
        expect(page).to have_message(blank_error_message, in: 'div.professor_name')
        expect(page).to have_message(blank_error_message, in: 'div.professor_lattes')
        expect(page).to have_message(invalid_error_message, in: 'div.professor_email')
        expect(page).to have_message(image_error_message, in: 'div.professor_profile_image')
        expect(page).to have_message(confirm_password_error_message,
                                     in: 'div.professor_current_password')
      end
    end
  end
end
