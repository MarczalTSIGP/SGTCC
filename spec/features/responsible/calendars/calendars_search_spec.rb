require 'rails_helper'

describe 'Calendar::search', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:calendars) { create_list(:calendar, 2) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_calendars_path
  end

  describe '#search' do
    context 'when finds the calendar' do
      it 'finds the calendar by the year', js: true do
        calendar = calendars.first

        fill_in 'term', with: calendar.year
        first('#search').click

        expect(page).to have_contents([calendar.year,
                                       I18n.t("enums.tcc.#{calendar.tcc}"),
                                       I18n.t("enums.semester.#{calendar.semester}"),
                                       short_date(calendar.created_at)])
      end
    end

    context 'when the result is not found' do
      it 'returns not found message', js: true do
        fill_in 'term', with: 'a1#\231/ere'
        first('#search').click

        expect(page).to have_message(I18n.t('helpers.no_results'), in: 'table tbody')
      end
    end
  end
end
