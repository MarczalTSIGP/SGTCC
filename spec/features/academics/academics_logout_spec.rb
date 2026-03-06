require 'rails_helper'

describe 'Academics:logout', :js do
  let!(:calendar) do
    create(
      :calendar,
      start_date: Date.current.beginning_of_year,
      end_date: Date.current.end_of_year
    )
  end

  let(:academic) { create(:academic) }

  before do
    login_as(academic, scope: :academic)
    visit academics_root_path
  end

  it 'displays success logout message' do
    find('[data-testid="user-menu"]').click
    click_button I18n.t('sessions.sign_out')

    expect(page).to have_current_path new_academic_session_path
    expect(page).to have_flash(:info, text: already_signed_out_message)
  end
end
