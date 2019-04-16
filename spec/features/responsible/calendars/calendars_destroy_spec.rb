require 'rails_helper'

describe 'Calendar::destroy', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Calendar.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#destroy' do
    context 'when calendar is destroyed', js: true do
      it 'show success message' do
        calendar = create(:calendar)
        visit responsible_calendars_path

        within first('.destroy').click

        alert = page.driver.browser.switch_to.alert
        alert.accept
        sleep 2.seconds

        success_message = I18n.t('flash.actions.destroy.m', resource_name: resource_name)
        expect(page).to have_flash(:success, text: success_message)

        expect(page).not_to have_content(calendar.year)
      end
    end
  end
end
