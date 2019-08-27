require 'rails_helper'

describe 'Calendar::search', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:calendars) { create_list(:calendar_tcc_one, 2) }

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
        expect(page).to have_contents([calendar.year_with_semester,
                                       I18n.t("enums.tcc.#{calendar.tcc}"),
                                       short_date(calendar.created_at)])
      end
    end

    context 'when the result is not found' do
      it 'returns not found message' do
        fill_in 'term', with: 'a1#\231/ere'
        first('#search').click
        expect(page).to have_message(no_results_message, in: 'table tbody')
      end
    end
  end
end
