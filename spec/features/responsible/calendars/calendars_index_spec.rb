require 'rails_helper'

describe 'Calendar::index', type: :feature do
  describe '#index' do
    context 'when shows all calendars' do
      it 'shows all tcc 1 calendars with options', js: true do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        calendars = create_list(:calendar_tcc_one, 3)

        index_url = responsible_calendars_tcc_one_path
        visit index_url

        calendars.each do |calendar|
          expect(page).to have_contents([calendar.year,
                                         I18n.t("enums.tcc.#{calendar.tcc}"),
                                         I18n.t("enums.semester.#{calendar.semester}"),
                                         short_date(calendar.created_at)])
        end
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end

      it 'shows all tcc 2 calendars with options', js: true do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        calendars = create_list(:calendar_tcc_two, 3)

        index_url = responsible_calendars_tcc_two_path
        visit index_url

        calendars.each do |calendar|
          expect(page).to have_contents([calendar.year,
                                         I18n.t("enums.tcc.#{calendar.tcc}"),
                                         I18n.t("enums.semester.#{calendar.semester}"),
                                         short_date(calendar.created_at)])
        end
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end
