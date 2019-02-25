require 'rails_helper'

describe 'Professors:Sessions', type: :feature do
  it "displays the professor's perfil links after successful login" do
    professor = create(:professor)

    visit new_professor_session_path

    fill_in 'professor_username', with: professor.username
    fill_in 'professor_password', with: 'password'

    submit_form

    expect(page).to have_current_path professors_root_path

    expect(page).to have_flash(:info, text: I18n.t('devise.sessions.signed_in'))
  end

  it "displays the professor's error message when user or password is wrong" do
    professor = create(:professor)

    visit new_professor_session_path

    fill_in 'professor_username', with: professor.username
    fill_in 'professor_password', with: 'passworda'

    submit_form

    expect(page).to have_current_path new_professor_session_path

    resource_name = Professor.human_attribute_name(:username)
    expect(page).to have_flash(:warning,
                               text: I18n.t('devise.failure.invalid',
                                            authentication_keys: resource_name))
  end

  it 'displays success logout message when the user click on logout' do
    professor = create(:professor)
    login_as(professor, scope: :professor)

    visit professors_root_url

    click_link professor.name
    click_link(I18n.t('sessions.sign_out'))

    expect(page).to have_current_path new_professor_session_path

    expect(page).to have_flash(:info, text: I18n.t('devise.sessions.already_signed_out'))
  end
end
