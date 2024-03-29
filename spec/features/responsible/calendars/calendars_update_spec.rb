require 'rails_helper'

describe 'Calendar::update', :js do
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

    context 'when data is valid' do
      it 'updates the calendar' do
        attributes = attributes_for(:calendar, tcc: 2)
        fill_in 'calendar_year', with: attributes[:year]
        click_on_label(attributes[:tcc], in: 'calendar_tcc')
        click_on_label(attributes[:semester], in: 'calendar_semester')
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_calendars_tcc_two_path
        expect(page).to have_flash(:success, text: message('update.m'))
        expect(page).to have_contents([attributes[:year],
                                       attributes[:tcc],
                                       attributes[:semester]])
      end
    end

    context 'when the calendar is not valid' do
      it 'show errors' do
        fill_in 'calendar_year', with: ''
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.calendar_year')
      end
    end
  end
end
