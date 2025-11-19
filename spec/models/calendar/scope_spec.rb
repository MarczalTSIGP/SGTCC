require 'rails_helper'

RSpec.describe Calendar, type: :model do
  describe '#search_by_tcc' do
    let!(:calendar_tcc_one) { create(:current_calendar_tcc_one) }
    let!(:calendar_tcc_two) { create(:current_calendar_tcc_two) }

    it 'finds calendar by tcc one' do
      results = described_class.search_by_tcc_one(1, calendar_tcc_one.year)
      expect(results.first.year).to eq(calendar_tcc_one.year)
    end

    it 'finds calendar by tcc two' do
      results = described_class.search_by_tcc_two(1, calendar_tcc_two.year)
      expect(results.first.year).to eq(calendar_tcc_two.year)
    end
  end

  describe '#current_by_tcc' do
    it 'returns current by tcc one' do
      calendar = create(:current_calendar_tcc_one)
      expect(described_class.current_by_tcc_one).to eq(calendar)
    end

    it 'returns current by tcc two' do
      calendar = create(:current_calendar_tcc_two)
      expect(described_class.current_by_tcc_two).to eq(calendar)
    end
  end

    it 'returns first semester of next year' do
      current = create(:current_calendar_tcc_one, semester: 2)
      next_cal = create(:current_calendar_tcc_one, semester: 1, year: current.year.to_i + 1)
      expect(described_class.next_semester(current)).to eq(next_cal)
    end
  end
