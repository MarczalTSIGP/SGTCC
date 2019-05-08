require 'rails_helper'

describe 'Professor::update', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { professor.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#update' do
    let(:professor) { create(:professor) }

    before do
      visit edit_responsible_professor_path(professor)
    end

    context 'when data is valid' do
      it 'updates the professor' do
        attributes = attributes_for(:professor)
        new_name = 'Teste'

        fill_in 'professor_name', with: new_name
        fill_in 'professor_email', with: attributes[:email]

        submit_form('input[name="commit"]')
        expect(page).to have_current_path responsible_professor_path(professor)
        expect(page).to have_flash(:success, text: flash_message('update.m', resource_name))
        expect(page).to have_content(new_name)
      end
    end

    context 'when the professor is not valid' do
      it 'show errors' do
        fill_in 'professor_name', with: ''
        fill_in 'professor_email', with: ''
        fill_in 'professor_lattes', with: ''
        fill_in 'professor_username', with: ''

        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect(page).to have_message(message_blank_error, in: 'div.professor_name')
        expect(page).to have_message(message_blank_error, in: 'div.professor_email')
        expect(page).to have_message(message_blank_error, in: 'div.professor_username')
        expect(page).to have_message(message_blank_error, in: 'div.professor_gender')
        expect(page).to have_message(message_blank_error, in: 'div.professor_lattes')
      end
    end
  end
end
