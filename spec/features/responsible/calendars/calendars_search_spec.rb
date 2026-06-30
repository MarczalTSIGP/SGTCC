require 'rails_helper'

describe 'Calendar::search', :js do
  let(:responsible) { create(:responsible) }
  let(:calendars) { create_list(:calendar, 2, :tcc_one) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_calendars_tcc_one_path
  end

  describe '#search' do
    context 'when finds the calendar' do
      it 'finds the calendar by the year' do
        calendar = calendars.first

        fill_in 'term', with: calendar.year
        first('#search').click

        expect(page).to have_link(calendar.year_with_semester,
                                  href: responsible_calendar_path(calendar))

        expect(page).to have_contents([
                                        I18n.t("enums.tcc.#{calendar.tcc}"),
                                        short_date(calendar.start_date),
                                        short_date(calendar.end_date)
                                      ])
      end
    end

    it_behaves_like 'responsible search with no results', 'a1#\231/ere'
  end
end
