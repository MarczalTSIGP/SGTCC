require 'rails_helper'

describe 'Professors:logout', type: :feature do
  let(:professor) { create(:professor) }

  before(:each) do
    login_as(professor, scope: :professor)

    visit professors_root_url
  end

  it 'displays success logout message when the user click on logout' do
    click_link professor.email
    click_link(I18n.t('sessions.sign_out'))

    expect(page.current_path).to eq new_professor_session_path

    expect(page).to have_selector(
      'div.alert.alert-info',
      text: I18n.t('devise.sessions.already_signed_out')
    )
  end
end
