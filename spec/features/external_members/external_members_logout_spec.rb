require 'rails_helper'

describe 'ExternalMember:logout', type: :feature, js: true do
  let(:external_member) { create(:external_member) }

  before do
    login_as(external_member, scope: :external_member)
    visit external_members_root_path
  end

  it 'displays success logout message' do
    click_link external_member.name
    click_link(sign_out_button)

    expect(page).to have_current_path new_external_member_session_path
    expect(page).to have_flash(:info, text: already_signed_out_message)
  end
end
