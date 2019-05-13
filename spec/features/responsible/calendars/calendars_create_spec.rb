require 'rails_helper'

describe 'Calendar::create', type: :feature, js: true do
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
        radio('1', in: 'calendar_tcc')
        radio('1', in: 'calendar_semester')
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_calendars_tcc_one_path
        expect(page).to have_flash(:success, text: flash_message('create.m', resource_name))
        expect(page).to have_message(attributes[:name], in: 'table tbody')
      end
    end

    context 'when calendar is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect(page).to have_message(message_blank_error, in: 'div.calendar_year')
        expect(page).to have_message(message_blank_error, in: 'div.calendar_tcc')
        expect(page).to have_message(message_blank_error, in: 'div.calendar_semester')
      end
    end
  end
end
