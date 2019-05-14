require 'rails_helper'

describe 'Orientation::update', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:orientation) { create(:orientation) }
  let(:resource_name) { Orientation.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit edit_responsible_orientation_path(orientation)
  end

  describe '#update', js: true do
    context 'when data is valid' do
      it 'updates the orientation' do
        attributes = attributes_for(:orientation)
        fill_in 'orientation_title', with: attributes[:title]
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_orientation_path(orientation)
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(page).to have_content(attributes[:title])
      end
    end

    context 'when the orientation is not valid' do
      it 'show errors' do
        fill_in 'orientation_title', with: ''
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.orientation_title')
      end
    end
  end
end
