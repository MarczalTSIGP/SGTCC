require 'rails_helper'

describe 'Meeting::create', type: :feature, js: true do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let(:resource_name) { Meeting.model_name.human }

  before do
    professor.orientations << orientation
    login_as(professor, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_professors_meeting_path
    end

    context 'when meeting is valid' do
      it 'create a meeting' do
        attributes = attributes_for(:meeting)
        selectize(orientation.title, from: 'meeting_orientation_id')
        fill_in 'meeting_title', with: attributes[:title]
        find('.fa-bold').click
        submit_form('input[name="commit"]')

        expect(page).to have_current_path professors_meetings_path
        expect(page).to have_flash(:success, text: message('create.f'))
        expect(page).to have_message(attributes[:title], in: 'table tbody')
      end
    end

    context 'when meeting is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.meeting_title')
        expect(page).to have_message(blank_error_message, in: 'div.meeting_content')
        expect(page).to have_message(required_error_message, in: 'div.meeting_orientation')
      end
    end
  end
end
