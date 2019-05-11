require 'rails_helper'

describe 'BaseActivity::create', type: :feature, js: true do
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

    context 'when base_activity is valid' do
      it 'create a base activity with tcc 1' do
        attributes = attributes_for(:base_activity)
        fill_in 'base_activity_name', with: attributes[:name]
        find('span[class="custom-control-label"]', text: '1').click
        selectize(base_activity_types.first.name, from: 'base_activity_base_activity_type_id')
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_base_activities_tcc_one_path
        expect(page).to have_flash(:success, text: flash_message('create.f', resource_name))
        expect(page).to have_message(attributes[:name], in: 'table tbody')
      end

      it 'create a base activity with tcc 2' do
        attributes = attributes_for(:base_activity)
        fill_in 'base_activity_name', with: attributes[:name]
        find('span[class="custom-control-label"]', text: '2').click
        selectize(base_activity_types.first.name, from: 'base_activity_base_activity_type_id')

        submit_form('input[name="commit"]')
        expect(page).to have_current_path responsible_base_activities_tcc_two_path
        expect(page).to have_flash(:success, text: flash_message('create.f', resource_name))
        expect(page).to have_message(attributes[:name], in: 'table tbody')
      end
    end

    context 'when base activity is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect(page).to have_message(message_blank_error, in: 'div.base_activity_name')
        expect(page).to have_message(
          message_required_error, in: 'div.base_activity_base_activity_type'
        )
        expect(page).to have_message(
          message_blank_error, in: 'div.base_activity_tcc'
        )
      end
    end
  end
end
