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
        within first('span[class="custom-control-label"]').click
        within all('span[class="custom-control-label"]').last.click

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_calendars_tcc_one_path
        expect(page).to have_flash(:success, text: flash_message('create.m', resource_name))
        expect_page_has_content(attributes[:name], in: 'table tbody')
      end
    end

    context 'when calendar is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect_page_has_content(message_blank_error, in: 'div.calendar_year')
        expect_page_has_content(message_blank_error, in: 'div.calendar_tcc')
        expect_page_has_content(message_blank_error, in: 'div.calendar_semester')
      end
    end
  end
end
