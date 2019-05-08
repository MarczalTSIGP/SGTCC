require 'rails_helper'

describe 'Academics:login', type: :feature, js: true do
  let(:academic) { create(:academic) }

  before do
    visit new_academic_session_path
  end

  it 'displays the academics perfil links on valid login' do
    fill_in 'academic_ra', with: academic.ra
    fill_in 'academic_password', with: 'password'

    submit_form('input[name="commit"]')

    expect(page).to have_current_path academics_root_path
    expect(page).to have_flash(:info, text: I18n.t('devise.sessions.signed_in'))
  end

  it 'displays the academics error' do
    fill_in 'academic_ra', with: academic.ra
    fill_in 'academic_password', with: 'passworda'

    submit_form('input[name="commit"]')

    expect(page).to have_current_path new_academic_session_path

    resource_name = Academic.human_attribute_name(:ra)
    expect(page).to have_flash(:warning,
                               text: I18n.t('devise.failure.invalid',
                                            authentication_keys: resource_name))
  end

  context 'when academic is not authenticated' do
    before do
      visit academics_root_path
    end

    it 'redirect to login page' do
      expect(page).to have_current_path new_academic_session_path
      expect(page).to have_flash(:warning, text: I18n.t('devise.failure.unauthenticated'))
    end
  end
end
