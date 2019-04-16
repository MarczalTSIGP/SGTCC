require 'rails_helper'

describe 'Calendar::show', type: :feature do
  describe '#show' do
    context 'when shows the calendar' do
      it 'shows the calendar' do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        calendar = create(:calendar)
        visit responsible_calendar_path(calendar)

        tcc = I18n.t("enums.tcc.#{calendar.tcc}")
        semester = I18n.t("enums.semester.#{calendar.semester}")

        expect(page).to have_contents([calendar.year,
                                       tcc,
                                       semester,
                                       complete_date(calendar.created_at),
                                       complete_date(calendar.updated_at)])
      end
    end
  end
end
