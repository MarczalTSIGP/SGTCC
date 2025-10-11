require 'rails_helper'

describe 'Meeting::view', :js do
  let(:academic) { create(:academic) }
  let(:orientation) { create(:orientation, academic:) }
  let(:meeting) { create(:meeting, orientation:) }
  let(:resource_name) { Meeting.model_name.human }

  before do
    login_as(academic, scope: :academic)
    visit academics_meeting_path(meeting)
  end

  describe '#view' do
    context 'when mark as viewed the meeting' do
      it 'shows success message' do
        click_on_label(confirm_judgment_label, in: 'meeting_viewed')
        first('.swal-button--danger').click

        expect(page).to have_selector('.swal-modal', visible: true)
        expect(find('.swal-modal')).to have_content(message('update.f'))
      end
    end
  end
end
