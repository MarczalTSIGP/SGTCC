require 'rails_helper'

describe 'Activity::create', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Activity.model_name.human }
  let(:calendar) { create(:calendar) }
  let!(:base_activity_types) { create_list(:base_activity_type, 3) }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_responsible_calendar_activity_path(calendar)
    end

    context 'when activity is valid', js: true do
      it 'create an activity with tcc 1' do
        attributes = attributes_for(:activity)
        tcc_one_text = '1'
        fill_in 'activity_name', with: attributes[:name]
        find('#activity_base_activity_type_id-selectized').click
        find('div.selectize-dropdown-content', text: base_activity_types.first.name).click
        find('span[class="custom-control-label"]', text: tcc_one_text).click

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_calendar_activities_tcc_one_path(calendar)

        success_message = I18n.t('flash.actions.create.m', resource_name: resource_name)
        expect(page).to have_flash(:success, text: success_message)
        expect(page).to have_message(attributes[:name], in: 'table tbody')
      end

      it 'create an activity with tcc 2' do
        attributes = attributes_for(:activity)
        tcc_two_text = '2'
        fill_in 'activity_name', with: attributes[:name]
        find('#activity_base_activity_type_id-selectized').click
        find('div.selectize-dropdown-content', text: base_activity_types.first.name).click
        find('span[class="custom-control-label"]', text: tcc_two_text).click

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_calendar_activities_tcc_two_path(calendar)

        success_message = I18n.t('flash.actions.create.m', resource_name: resource_name)
        expect(page).to have_flash(:success, text: success_message)
        expect(page).to have_message(attributes[:name], in: 'table tbody')
      end
    end

    context 'when activity is not valid', js: true do
      it 'show errors' do
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))

        message_blank_error = I18n.t('errors.messages.blank')
        expect(page).to have_message(message_blank_error, in: 'div.activity_name')
        expect(page).to have_message(
          message_blank_error, in: 'div.activity_base_activity_type'
        )
      end
    end
  end
end
