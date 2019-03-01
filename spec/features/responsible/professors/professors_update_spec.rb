require 'rails_helper'

describe 'Professor::update', type: :feature do
  let(:responsible) { create(:professor) }
  let(:resource_name) { professor.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#update' do
    let(:professor) { create(:professor) }

    before do
      visit edit_responsible_professor_path(professor)
    end

    context 'when data is valid', js: true do
      it 'updates the professor' do
        attributes = attributes_for(:professor)
        new_name = 'Teste'

        fill_in 'professor_name', with: new_name
        fill_in 'professor_email', with: attributes[:email]

        submit_form('input[name="commit"]')
        expect(page).to have_current_path responsible_professor_path(professor)

        success_message = I18n.t('flash.actions.update.m',
                                 resource_name: resource_name)

        expect(page).to have_flash(:success, text: success_message)
        expect(page).to have_content(new_name)
      end
    end

    context 'when the professor is not valid', js: true do
      it 'show errors' do
        fill_in 'professor_name', with: ''
        fill_in 'professor_email', with: ''
        fill_in 'professor_lattes', with: ''
        fill_in 'professor_username', with: ''

        submit_form('input[name="commit"]')

        expect(page).to have_selector('div.alert.alert-danger',
                                      text: I18n.t('flash.actions.errors'))

        within('div.professor_name') do
          expect(page).to have_content(I18n.t('errors.messages.blank'))
        end

        within('div.professor_email') do
          expect(page).to have_content(I18n.t('errors.messages.blank'))
        end

        within('div.professor_username') do
          expect(page).to have_content(I18n.t('errors.messages.blank'))
        end

        within('div.professor_lattes') do
          expect(page).to have_content(I18n.t('errors.messages.blank'))
        end
      end
    end
  end
end
