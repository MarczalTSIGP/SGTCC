require 'rails_helper'

describe 'ExternalMember:logout', type: :feature do
  let(:external_member) { create(:external_member) }

  before do
    login_as(external_member, scope: :external_member)
    visit external_members_root_path
  end

  it 'displays success logout message', js: true do
    click_link external_member.name
    click_link(I18n.t('sessions.sign_out'))

    expect(page).to have_current_path new_external_members_session_path

    expect(page).to have_flash(
      :info,
      text: I18n.t('devise.sessions.already_signed_out')
    )
  end
end
