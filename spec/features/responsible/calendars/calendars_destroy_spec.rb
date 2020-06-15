require 'rails_helper'

describe 'Calendar::destroy', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Calendar.model_name.human }
  let!(:calendar) { create(:calendar_tcc_one) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_calendars_tcc_one_path
  end

  describe '#destroy' do
    context 'when calendar is destroyed' do
      it 'show success message' do
        calendar.activities.delete_all
        click_on_destroy_link(responsible_calendar_path(calendar))
        accept_alert
        expect(page).to have_flash(:success, text: message('destroy.m'))
        expect(page).not_to have_content(calendar.year)
      end
    end

    context 'when calendar has associations' do
      let!(:activity) { create(:activity, calendar: calendar) }

      it 'show alert message' do
        click_on_destroy_link(responsible_calendar_path(activity.calendar))
        accept_alert

        expect(page).to have_flash(:warning, text: message('destroy.bond'))
        expect(page).to have_content(calendar.year)
      end
    end
  end
end
