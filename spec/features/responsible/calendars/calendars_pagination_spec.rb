require 'rails_helper'

describe 'Calendar::pagination', type: :feature do
  describe '#pagination' do
    context 'when finds the last calendar on second page' do
      it 'finds the last calendar', js: true do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        create_list(:calendar, 30)
        visit responsible_calendars_path
        calendar = Calendar.order(:year, :tcc, :semester).last

        click_link(2)

        expect(page).to have_contents([calendar.year,
                                       I18n.t("enums.tcc.#{calendar.tcc}"),
                                       I18n.t("enums.semester.#{calendar.semester}"),
                                       short_date(calendar.created_at)])
      end
    end
  end
end
