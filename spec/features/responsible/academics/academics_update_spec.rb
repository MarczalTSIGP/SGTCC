require 'rails_helper'

describe 'Academics', type: :feature do
  let(:professor) { create(:professor) }
  let(:resource_name) { Academic.model_name.human }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#update' do
    let(:academic) { create(:academic) }

    before do
      visit edit_responsible_academic_path(academic)
    end

    context 'with valid fields', js: true do
      it 'update academic' do
        attributes = attributes_for(:academic)

        new_name = 'Teste'
        fill_in 'academic_name', with: new_name
        fill_in 'academic_email', with: attributes[:email]

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_academic_path(academic)
        expect_alert_success(resource_name, 'flash.actions.update.m')

        expect(page).to have_content(new_name)
      end
    end

    context 'with invalid fields', js: true do
      it 'show errors' do
        fill_in 'academic_name', with: ''
        fill_in 'academic_email', with: ''
        submit_form('input[name="commit"]')

        expect(page).to have_selector('div.alert.alert-danger',
                                      text: I18n.t('flash.actions.errors'))

        within('div.academic_name') do
          expect(page).to have_content(I18n.t('errors.messages.blank'))
        end

        within('div.academic_email') do
          expect(page).to have_content(I18n.t('errors.messages.blank'))
        end
      end
    end
  end
end
