require 'spec_helper'

describe 'Professors:Profiles', type: :feature do
  context 'when update a professor' do
    let(:professor) { create(:professor) }

    before do
      login_as(professor, scope: :professor)
    end

    it 'updates with success when the data are valid' do
      visit edit_professor_registration_path

      fill_in Professor.human_attribute_name(:email), with: 'email@email.com'
      fill_in I18n.t('simple_form.labels.defaults.current_password'), with: professor.password

      submit_form

      expect(page).to have_current_path edit_professor_registration_path
      expect(page).to have_selector('div.alert.alert-info',
                                    text: I18n.t('devise.registrations.updated'))
    end

    it 'does not update with invalid date, ao show a error message' do
      visit edit_professor_registration_path

      fill_in Professor.human_attribute_name(:email), with: 'email'
      fill_in Professor.human_attribute_name(:password), with: 'abc123'
      fill_in Professor.human_attribute_name(:password_confirmation), with: 'abc123'
      fill_in I18n.t('simple_form.labels.defaults.current_password'), with: professor.password

      expect do
        submit_form
      end.to change(Professor, :count).by(0)

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
    end
  end
end
