require 'rails_helper'

describe 'Activity::update', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Activity.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#update' do
    let(:activity) { create(:activity) }

    before do
      visit edit_responsible_calendar_activity_path(activity.calendar, activity)
    end

    context 'when data is valid' do
      it 'updates the activity' do
        new_name = 'Teste'
        fill_in 'activity_name', with: new_name
        submit_form('input[name="commit"]')

        current_path = responsible_calendar_activity_path(activity.calendar, activity)
        expect(page).to have_current_path current_path
        expect(page).to have_flash(:success, text: flash_message('update.f', resource_name))
        expect(page).to have_content(new_name)
      end
    end

    context 'when the activity is not valid' do
      it 'show errors' do
        fill_in 'activity_name', with: ''
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect_page_has_content(message_blank_error, in: 'div.activity_name')
      end
    end
  end
end
