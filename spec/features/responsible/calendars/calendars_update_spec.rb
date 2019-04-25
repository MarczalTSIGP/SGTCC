require 'rails_helper'

describe 'Calendar::update', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Calendar.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#update' do
    let(:calendar) { create(:calendar_tcc_two) }

    before do
      visit edit_responsible_calendar_path(calendar)
    end

    context 'when data is valid', js: true do
      it 'updates the calendar' do
        new_year = '2018'
        fill_in 'calendar_year', with: new_year

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_calendars_tcc_two_path
        success_message = I18n.t('flash.actions.update.m', resource_name: resource_name)
        expect(page).to have_flash(:success, text: success_message)
        expect(page).to have_content(new_year)
      end
    end

    context 'when the calendar is not valid', js: true do
      it 'show errors' do
        fill_in 'calendar_year', with: ''
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))

        message_blank_error = I18n.t('errors.messages.blank')
        expect(page).to have_message(message_blank_error, in: 'div.calendar_year')
      end
    end
  end
end
