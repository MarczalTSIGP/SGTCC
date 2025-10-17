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
        accept_confirm 'Você tem certeza?' do
          find('#acknowledge_form .acknowledge_submit').click
        end

        within('form#acknowledge_form') do
          expect(page).to have_checked_field('completed', disabled: true, visible: :all)
        end
      end
    end
  end
end
