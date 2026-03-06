require 'rails_helper'

describe 'Calendar::destroy', :js do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Calendar.model_name.human } # << REINSERIDO
  let!(:calendar) { create(:calendar_tcc_one) }

  before do
    calendar.activities.destroy_all if calendar.respond_to?(:activities)
    login_as(responsible, scope: :professor)
    visit send("responsible_calendars_tcc_#{calendar.tcc}_path")
  end

  describe '#destroy' do
    context 'when calendar is destroyed' do
      it 'shows success message' do
        click_on_destroy_link(responsible_calendar_path(calendar))
        accept_alert

        expect(page).to have_content(message('destroy.m'))
        expect(page).to have_no_content(calendar.year)
      end
    end

    context 'when calendar has associations' do
      let!(:activity) { create(:activity, calendar: calendar) }

      it 'shows alert message' do
        click_on_destroy_link(responsible_calendar_path(calendar))
        accept_alert

        expect(page).to have_flash(:warning, text: message('destroy.bond'))
        expect(page).to have_content(calendar.year)
      end
    end
  end
end
