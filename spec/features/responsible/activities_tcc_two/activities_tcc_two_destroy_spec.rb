require 'rails_helper'

describe 'Activity::destroy', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Activity.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#destroy' do
    context 'when activity is destroyed', js: true do
      it 'show success message' do
        calendar = create(:calendar_tcc_two)
        activity = create(:activity_tcc_two, calendar: calendar)
        visit responsible_calendar_activities_tcc_two_index_path(calendar)

        within first('.destroy').click

        alert = page.driver.browser.switch_to.alert
        alert.accept
        sleep 2.seconds

        success_message = I18n.t('flash.actions.destroy.m', resource_name: resource_name)
        expect(page).to have_flash(:success, text: success_message)
        expect(page).not_to have_content(activity.name)
      end
    end
  end
end
