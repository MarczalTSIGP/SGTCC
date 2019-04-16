require 'rails_helper'

describe 'Calendar::index', type: :feature do
  describe '#index' do
    context 'when shows all calendars' do
      it 'shows all calendars with options', js: true do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        calendars = create_list(:calendar, 3)

        visit responsible_calendars_path

        calendars.each do |calendar|
          expect(page).to have_contents([calendar.year,
                                         I18n.t("enums.tcc.#{calendar.tcc}"),
                                         I18n.t("enums.semester.#{calendar.semester}"),
                                         short_date(calendar.created_at)])
        end
      end
    end
  end
end
