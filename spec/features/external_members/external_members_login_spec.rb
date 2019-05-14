require 'rails_helper'

describe 'ExternalMember:login', type: :feature, js: true do
  let(:external_member) { create(:external_member) }
  let(:resource_name) { ExternalMember.human_attribute_name(:email) }

  before do
    visit new_external_member_session_path
  end

  it 'displays the external_members perfil links on valid login' do
    fill_in 'external_member_email', with: external_member.email
    fill_in 'external_member_password', with: 'password'

    submit_form('input[name="commit"]')

    expect(page).to have_current_path external_members_root_path
    expect(page).to have_flash(:info, text: signed_in_message)
  end

  it 'displays the external_members error' do
    fill_in 'external_member_email', with: external_member.email
    fill_in 'external_member_password', with: 'passworda'
    submit_form('input[name="commit"]')

    expect(page).to have_current_path new_external_member_session_path
    expect(page).to have_flash(:warning, text: invalid_sign_in_message)
  end

  context 'when external_member is not authenticated' do
    before do
      visit external_members_root_path
    end

    it 'redirect to login page' do
      expect(page).to have_current_path new_external_member_session_path
      expect(page).to have_flash(:warning, text: unauthenticated_message)
    end
  end
end
