require 'rails_helper'

RSpec.describe Site do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe '#select_calendar_years' do
    before do
      create(:calendar, year: 2019)
      create(:calendar, year: 2018)
    end

    it 'returns the calendar years' do
      years = described_class.select_calendar_years
      expect(years).to include('2019', '2018')
      expect(years.index('2019')).to be < years.index('2018')
    end
  end
end
