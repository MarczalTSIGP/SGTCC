require 'rails_helper'

describe 'ExternalMember:login', type: :feature do
  let(:external_member) { create(:external_member) }

  before do
    visit new_external_member_session_path
  end

  it 'displays the external_members perfil links on valid login', js: true do
    fill_in 'external_member_email', with: external_member.email
    fill_in 'external_member_password', with: 'password'

    submit_form('input[name="commit"]')

    expect(page).to have_current_path external_members_root_path
    expect(page).to have_flash(:info, text: I18n.t('devise.sessions.signed_in'))
  end

  it 'displays the external_members error', js: true do
    fill_in 'external_member_email', with: external_member.email
    fill_in 'external_member_password', with: 'passworda'

    submit_form('input[name="commit"]')

    expect(page).to have_current_path new_external_member_session_path

    resource_name = ExternalMember.human_attribute_name(:email)
    expect(page).to have_flash(:warning,
                               text: I18n.t('devise.failure.invalid',
                                            authentication_keys: resource_name))
  end

  context 'when external_member is not authenticated' do
    before do
      visit external_members_root_path
    end

    it 'redirect to login page', js: true do
      expect(page).to have_current_path new_external_member_session_path
      expect(page).to have_flash(:warning, text: I18n.t('devise.failure.unauthenticated'))
    end
  end
end
