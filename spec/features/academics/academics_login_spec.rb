require 'rails_helper'

describe 'Academics:login', :js do
  let(:academic) { create(:academic) }
  let(:resource_name) { Academic.human_attribute_name(:ra) }

  before do
    visit new_academic_session_path
  end

  it 'displays the academics perfil links on valid login' do
    fill_in 'academic_ra', with: academic.ra
    fill_in 'academic_password', with: 'password'
    submit_form('input[name="commit"]')

    expect(page).to have_current_path academics_root_path
    expect(page).to have_flash(:info, text: signed_in_message)
  end

  it 'displays the academics error' do
    fill_in 'academic_ra', with: academic.ra
    fill_in 'academic_password', with: 'passworda'
    submit_form('input[name="commit"]')

    expect(page).to have_current_path new_academic_session_path
    expect(page).to have_flash(:warning, text: invalid_sign_in_message)
  end

  context 'when academic is not authenticated' do
    before do
      visit academics_root_path
    end

    it 'redirect to login page' do
      expect(page).to have_current_path new_academic_session_path
      expect(page).to have_flash(:warning, text: unauthenticated_message)
    end
  end
end
