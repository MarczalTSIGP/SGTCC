require 'rails_helper'

describe 'Calendar::update', :js do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Calendar.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#update' do
    let(:calendar) { create(:calendar, :tcc_two) }

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

        start_value = attributes[:start_date].strftime('%d/%m/%Y')
        end_value   = attributes[:end_date].strftime('%d/%m/%Y')

        first('input[data-forms--datetimepicker-target="field"]').set(start_value)
        all('input[data-forms--datetimepicker-target="field"]')[1].set(end_value)

        page.find('body').click
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
      it_behaves_like 'responsible update blank errors',
                      fields: %w[calendar_year],
                      selectors: [
                        ['div.calendar_year']
                      ],
                      description: 'shows errors'
    end
  end
end
