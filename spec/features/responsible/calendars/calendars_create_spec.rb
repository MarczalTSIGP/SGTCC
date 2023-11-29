require 'rails_helper'

describe 'Calendar::create', :js do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Calendar.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit new_responsible_calendar_path
  end

  describe '#create' do
    context 'when calendar is valid' do
      it 'create a calendar' do
        attributes = attributes_for(:calendar)
        fill_in 'calendar_year', with: attributes[:year]
        click_on_label('1', in: 'calendar_tcc')
        click_on_label('1', in: 'calendar_semester')
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_calendars_tcc_one_path
        expect(page).to have_flash(:success, text: message('create.m'))
        expect(page).to have_message(attributes[:name], in: 'table tbody')
      end
    end

    context 'when calendar is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.calendar_year')
        expect(page).to have_message(blank_error_message, in: 'div.calendar_tcc')
        expect(page).to have_message(blank_error_message, in: 'div.calendar_semester')
      end
    end
  end
end
