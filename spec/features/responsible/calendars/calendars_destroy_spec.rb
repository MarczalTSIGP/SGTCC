require 'rails_helper'

describe 'Calendar::destroy', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Calendar.model_name.human }
  let!(:calendar) { create(:calendar_tcc_one) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_calendars_tcc_one_path
  end

  describe '#destroy' do
    context 'when calendar is destroyed', js: true do
      it 'show success message' do
        within first('.destroy').click
        accept_alert

        expect(page).to have_flash(:success, text: flash_message('destroy.m', resource_name))
        expect(page).not_to have_content(calendar.year)
      end
    end

    context 'when calendar has associations', js: true do
      it 'show alert message' do
        create(:activity, calendar: calendar)
        within first('.destroy').click
        accept_alert

        expect(page).to have_flash(:warning, text: flash_message('destroy.bond', resource_name))
        expect(page).to have_content(calendar.year)
      end
    end
  end
end
