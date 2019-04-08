require 'rails_helper'

describe 'BaseActivity::create', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { BaseActivity.model_name.human }
  let!(:base_activity_types) { create_list(:base_activity_type, 3) }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_responsible_base_activity_path
    end

    context 'when base_activity is valid', js: true do
      it 'create a base activity' do
        attributes = attributes_for(:base_activity)
        fill_in 'base_activity_name', with: attributes[:name]
        find('#base_activity_base_activity_type_id-selectized').click
        find('div.selectize-dropdown-content', text: base_activity_types.first.name).click
        find('span[class="custom-control-label"]', text: BaseActivity.human_tccs.first[0]).click

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_base_activities_path

        success_message = I18n.t('flash.actions.create.m', resource_name: resource_name)
        expect(page).to have_flash(:success, text: success_message)
        expect(page).to have_message(attributes[:name], in: 'table tbody')
      end
    end

    context 'when base activity is not valid', js: true do
      it 'show errors' do
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))

        message_blank_error = I18n.t('errors.messages.blank')
        expect(page).to have_message(message_blank_error, in: 'div.base_activity_name')
        expect(page).to have_message(
          message_blank_error, in: 'div.base_activity_base_activity_type'
        )
      end
    end
  end
end
