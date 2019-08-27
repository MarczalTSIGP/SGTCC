require 'rails_helper'

describe 'Academics:logout', type: :feature, js: true do
  let(:academic) { create(:academic) }

  before do
    login_as(academic, scope: :academic)
    visit academics_root_path
  end

  it 'displays success logout message' do
    click_link academic.name
    click_link(sign_out_button)

    expect(page).to have_current_path new_academic_session_path
    expect(page).to have_flash(:info, text: already_signed_out_message)
  end
end
