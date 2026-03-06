require 'rails_helper'

RSpec.describe Calendar, type: :model do
  describe '#search' do
    let(:calendar) { create(:current_calendar) }

    it 'finds calendar by year' do
      results = described_class.search(calendar.year)
      expect(results.first.year).to eq(calendar.year)
    end

    it 'returns calendars ordered by year' do
      create(:calendar, year: '2022')
      create(:calendar, year: '2023')
      create(:calendar, year: '2024')

      expected = described_class.order(year: :desc).first.year
      results = described_class.search.order(year: :desc).first.year
      expect(results).to eq(expected)
    end
  end
end
