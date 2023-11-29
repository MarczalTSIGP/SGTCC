require 'rails_helper'

describe 'Activity::update', :js do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Activity.model_name.human }
  let(:activity) { create(:activity) }
  let!(:base_activity_types) { create_list(:base_activity_type, 3) }

  before do
    login_as(responsible, scope: :professor)
    visit edit_responsible_calendar_activity_path(activity.calendar, activity)
  end

  describe '#update' do
    context 'when data is valid' do
      it 'updates the activity' do
        attributes = attributes_for(:activity).merge(
          base_activity_type: base_activity_types.last
        )
        fill_in 'activity_name', with: attributes[:name]
        selectize(attributes[:base_activity_type].name, from: 'activity_base_activity_type_id')
        submit_form('input[name="commit"]')

        current_path = responsible_calendar_activities_path(activity.calendar)
        expect(page).to have_current_path current_path
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(page).to have_message(attributes[:name], in: 'table tbody')
      end
    end

    context 'when the activity is not valid' do
      it 'show errors' do
        fill_in 'activity_name', with: ''
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.activity_name')
      end
    end
  end
end
