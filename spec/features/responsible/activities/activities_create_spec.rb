require 'rails_helper'

describe 'Activity::create', :js do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Activity.model_name.human }
  let(:calendar) { create(:calendar, :tcc_one) }
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
        slim_select(base_activity_types.first.name, from: 'activity_base_activity_type_id')

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
      it_behaves_like 'responsible form blank errors',
                      [
                        ['div.activity_name'],
                        ['div.activity_base_activity_type', :required_error_message]
                      ]
    end
  end
end
