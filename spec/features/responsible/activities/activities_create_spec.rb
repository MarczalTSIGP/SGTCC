require 'rails_helper'

describe 'Activity::create', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Activity.model_name.human }
  let(:calendar) { create(:calendar) }
  let!(:base_activity_types) { create_list(:base_activity_type, 3) }

  before do
    login_as(responsible, scope: :professor)
    visit new_responsible_calendar_activity_path(calendar)
  end

  describe '#create' do
    context 'when activity is valid' do
      it 'create an activity' do
        attributes = attributes_for(:activity)
        fill_in 'activity_name', with: attributes[:name]
        selectize(base_activity_types.first.name, from: 'activity_base_activity_type_id')

        submit_form('input[name="commit"]')
        expect(page).to have_current_path responsible_calendar_activities_path(calendar)
        expect(page).to have_flash(:success, text: flash_message('create.f', resource_name))
        expect_page_has_content(attributes[:name], in: 'table tbody')
      end
    end

    context 'when activity is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect_page_has_content(message_blank_error, in: 'div.activity_name')
        expect_page_has_content(message_required_error, in: 'div.activity_base_activity_type')
      end
    end
  end
end
