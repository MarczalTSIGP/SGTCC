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
      it 'creates a calendar' do
        attributes = attributes_for(:calendar, tcc: :two, semester: :one)

        fill_in 'calendar_year', with: attributes[:year]

        tcc_text = I18n.t('enums.tcc.two')
        within('.col-2:nth-child(1)') do
          find('span.custom-control-label', text: tcc_text).click
        end

        semester_text = I18n.t('enums.semester.one')
        within('.col-2:nth-child(2)') do
          find('span.custom-control-label', text: semester_text).click
        end

        start_value = attributes[:start_date].strftime('%Y-%m-%d')
        end_value   = attributes[:end_date].strftime('%Y-%m-%d')

        page.execute_script(<<~JS)
          document.querySelector('#calendar_start_date').value = '#{start_value}';
          document.querySelector('#calendar_end_date').value   = '#{end_value}';
        JS

        submit_form('input[name="commit"]')

        expected_path = responsible_calendars_tcc_two_path
        expect(page).to have_current_path(expected_path)
        expect(page).to have_flash(:success, text: message('create.m'))

        # Ajuste do label exibido
        semester_number = attributes[:semester].to_s == 'one' ? 1 : 2
        calendar_label = "#{attributes[:year]}/#{semester_number}"

        expect(page).to have_content(calendar_label)
      end
    end
  end
end
