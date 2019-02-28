require 'rails_helper'

describe 'Academics:logout', type: :feature do
  let(:academic) { create(:academic) }

  before do
    login_as(academic, scope: :academic)
    visit academics_root_path
  end

  it 'displays success logout message', js: true do
    click_link academic.name
    click_link(I18n.t('sessions.sign_out'))

    expect(page).to have_current_path new_academics_session_path

    expect(page).to have_flash(
      :info,
      text: I18n.t('devise.sessions.already_signed_out')
    )
  end
end
