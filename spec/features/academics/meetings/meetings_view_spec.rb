require 'rails_helper'

describe 'Meeting::view', :js do
  let(:academic) { create(:academic) }
  let(:orientation) { create(:orientation, academic: academic) }
  let(:meeting) { create(:meeting, orientation: orientation) }
  let(:resource_name) { Meeting.model_name.human }

  before do
    login_as(academic, scope: :academic)
    visit academics_meeting_path(meeting)
  end

  describe '#view' do
    context 'when mark as viewed the meeting' do
      it 'shows success message' do
        click_on_label(confirm_judgment_label, in: 'meeting_viewed')
        find('.swal-button--danger', match: :first).click
        # expect(page).to have_alert(text: message('update.f'))
        expect(page).to have_css('div.swal-text', text: message('update.f'))
        find('.swal-button--confirm', match: :first).click
      end
    end
  end
end
