require 'rails_helper'

describe 'Basebase_activity::update', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { BaseActivity.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#update' do
    let(:base_activity) { create(:base_activity) }

    before do
      visit edit_responsible_base_activity_path(base_activity)
    end

    context 'when data is valid', js: true do
      it 'updates the base activity' do
        new_name = 'Teste'
        fill_in 'base_activity_name', with: new_name
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_base_activity_path(base_activity)
        success_message = I18n.t('flash.actions.update.m', resource_name: resource_name)
        expect(page).to have_flash(:success, text: success_message)
        expect(page).to have_content(new_name)
      end
    end

    context 'when the base activity is not valid', js: true do
      it 'show errors' do
        fill_in 'base_activity_name', with: ''
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect(page).to have_message(I18n.t('errors.messages.blank'), in: 'div.base_activity_name')
      end
    end
  end
end
