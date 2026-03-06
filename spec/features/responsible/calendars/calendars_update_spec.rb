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
        attributes = attributes_for(:calendar, tcc: :two, semester: :one)

        fill_in 'calendar_year', with: attributes[:year]
        tcc_text = I18n.t("enums.tcc.#{attributes[:tcc]}")
        within('.col-2:nth-child(1)') do
          find('span.custom-control-label', text: tcc_text).click
        end

        semester_text = I18n.t("enums.semester.#{attributes[:semester]}")
        within('.col-2:nth-child(2)') do
          find('span.custom-control-label', text: semester_text).click
        end

        start_value = attributes[:start_date].strftime('%Y-%m-%d')
        end_value   = attributes[:end_date].strftime('%Y-%m-%d')

        page.execute_script(<<~JS)
          var s = document.querySelector('input[name="calendar[start_date]"]');
          if (s) { s.value = '#{start_value}'; s.dispatchEvent(new Event('change', { bubbles: true })); }

          var e = document.querySelector('input[name="calendar[end_date]"]');
          if (e) { e.value = '#{end_value}'; e.dispatchEvent(new Event('change', { bubbles: true })); }
        JS
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_calendars_tcc_two_path
        expect(page).to have_flash(:success, text: message('update.m'))

        tcc_display = I18n.t("enums.tcc.#{attributes[:tcc]}")
        semester_display = I18n.t("enums.semester.#{attributes[:semester]}")

        expect(page).to have_contents([
                                        attributes[:year].to_s,
                                        tcc_display,
                                        semester_display
                                      ])
      end
    end

    context 'when the calendar is not valid' do
      it 'shows errors' do
        fill_in 'calendar_year', with: ''
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.calendar_year')
      end
    end
  end
end
