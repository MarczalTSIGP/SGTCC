require 'spec_helper'

describe 'Professors:update', type: :feature do
  let(:professor) { create(:professor) }

  before(:each) do
    login_as(professor, scope: :professor)
    visit edit_professor_registration_path
  end

  it 'should update a professor with valid fields' do
    fill_in Professor.human_attribute_name(:email), with: 'email@email.com'
    fill_in I18n.t('simple_form.labels.defaults.current_password'), with: professor.password

    submit_form

    expect(page.current_path).to eq edit_professor_registration_path
    expect(page).to have_selector('div.alert.alert-info',
                                  text:  I18n.t('devise.registrations.updated'))
  end

  it 'should not update a professor with invalid fields' do
    fill_in Professor.human_attribute_name(:email), with: 'email'
    fill_in Professor.human_attribute_name(:password), with: 'abc123'
    fill_in Professor.human_attribute_name(:password_confirmation), with: 'abc123'
    fill_in I18n.t('simple_form.labels.defaults.current_password'), with: professor.password

    expect do
      submit_form
    end.to change(Professor, :count).by(0)

    danger_message = I18n.t('simple_form.error_notification.default_message')
    expect(page).to have_selector('div.alert.alert-danger',
                                  text: danger_message)

    within('div.professor_email') do
      expect(page).to have_content(I18n.t('errors.messages.invalid'))
    end

    within('div.professor_current_password') do
      expect(page).to have_content(
        I18n.t('devise.registrations.edit.current_password_to_confirm')
      )
    end
  end
end
