require 'rails_helper'

describe 'Meeting::update', type: :feature, js: true do
  let(:professor) { create(:professor) }
  let(:resource_name) { Meeting.model_name.human }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#update' do
    let(:orientation) { create(:orientation, advisor: professor) }
    let(:meeting) { create(:meeting, orientation: orientation) }

    before do
      professor.orientations << orientation
      visit edit_professors_meeting_path(meeting)
    end

    context 'when data is valid' do
      it 'updates the meeting' do
        attributes = attributes_for(:meeting)
        fill_in 'meeting_title', with: attributes[:title]

        submit_form('input[name="commit"]')

        expect(page).to have_current_path professors_meeting_path(meeting)
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(page).to have_content(attributes[:title])
      end
    end

    context 'when the meeting is not valid' do
      it 'show errors' do
        fill_in 'meeting_title', with: ''
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.meeting_title')
      end
    end
  end
end
