require 'rails_helper'

describe 'Professors:logout', type: :feature do
  let(:professor) { create(:professor) }

  before do
    login_as(professor, scope: :professor)
    visit responsible_academics_path
  end

  it 'displays success logout message', js: true do
    click_link professor.email
    click_link(I18n.t('sessions.sign_out'))

    expect(page).to have_current_path new_responsible_session_path

    expect(page).to have_selector(
      'div.alert.alert-info',
      text: I18n.t('devise.sessions.already_signed_out')
    )
  end
end
