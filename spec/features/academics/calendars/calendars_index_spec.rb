require 'rails_helper'

describe 'Calendar::index', type: :feature, js: true do
  let(:academic) { create(:academic) }
  let!(:calendar) { create(:calendar_tcc_one) }

  before do
    login_as(academic, scope: :academic)
    create(:orientation, calendar: calendar, academic: academic)
  end

  describe '#index' do
    context 'when shows all calendars' do
      it 'shows all tcc 1 calendars with options' do
        index_url = academics_calendars_path
        visit index_url

        expect(page).to have_contents([calendar.year_with_semester,
                                       I18n.t("enums.tcc.#{calendar.tcc}"),
                                       short_date(calendar.created_at)])
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end
