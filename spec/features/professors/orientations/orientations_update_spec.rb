require 'rails_helper'

describe 'Orientation::update', type: :feature do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation) }
  let(:resource_name) { Orientation.model_name.human }

  before do
    login_as(professor, scope: :professor)
    visit edit_professors_orientation_path(orientation)
  end

  describe '#update', js: true do
    context 'when data is valid' do
      it 'updates the orientation' do
        new_title = 'Test new orientation'
        fill_in 'orientation_title', with: new_title
        submit_form('input[name="commit"]')

        expect(page).to have_current_path professors_orientation_path(orientation)
        success_message = I18n.t('flash.actions.update.f', resource_name: resource_name)
        expect(page).to have_flash(:success, text: success_message)
        expect(page).to have_content(new_title)
      end
    end

    context 'when the orientation is not valid' do
      it 'show errors' do
        fill_in 'orientation_title', with: ''
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect(page).to have_message(I18n.t('erros.messages.blank'), in: 'div.orientation_title')
      end
    end
  end
end
