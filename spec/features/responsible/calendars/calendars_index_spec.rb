require 'rails_helper'

describe 'Calendar::index', type: :feature, js: true do
  let(:responsible) { create(:responsible) }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#index' do
    context 'when shows all calendars' do
      it 'shows all tcc 1 calendars with options' do
        calendars = create_list(:calendar_tcc_one, 3)
        index_url = responsible_calendars_tcc_one_path
        visit index_url

        calendars.each do |calendar|
          expect(page).to have_link(calendar.year_with_semester,
                                    href: responsible_calendar_path(calendar))
          expect(page).to have_contents([I18n.t("enums.tcc.#{calendar.tcc}"),
                                         short_date(calendar.created_at)])
        end
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end

      it 'shows all tcc 2 calendars with options' do
        calendars = create_list(:calendar_tcc_two, 3)
        index_url = responsible_calendars_tcc_two_path
        visit index_url

        calendars.each do |calendar|
          expect(page).to have_link(calendar.year_with_semester,
                                    href: responsible_calendar_path(calendar))
          expect(page).to have_contents([I18n.t("enums.tcc.#{calendar.tcc}"),
                                         short_date(calendar.created_at)])
        end
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end
