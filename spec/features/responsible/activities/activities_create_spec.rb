require 'rails_helper'

describe 'Activity::create', :js do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Activity.model_name.human }
  let(:calendar) { create(:calendar_tcc_one) }
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
        click_on_label(Activity.human_tcc_one_identifiers.first[0], in: 'activity_identifier')
        selectize(base_activity_types.first.name, from: 'activity_base_activity_type_id')

        expect(page).to have_no_field('activity_identifier')
        expect(page).to have_no_field('activity_judgment')
        expect(page).to have_no_field('activity_final_version')

        submit_form('input[name="commit"]')
        expect(page).to have_current_path responsible_calendar_activities_path(calendar)
        expect(page).to have_flash(:success, text: message('create.f'))
        expect(page).to have_message(attributes[:name], in: 'table tbody')
      end
    end

    context 'when activity is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.activity_name')
        expect(page).to have_message(required_error_message, in: 'div.activity_base_activity_type')
      end
    end
  end
end
