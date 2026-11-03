require 'rails_helper'

RSpec.describe Calendars::ListQuery do
  describe '.call' do
    let!(:calendar_tcc_one) do
      find_or_create_calendar(year: Calendar.current_year,
                              semester: Calendar.current_semester, tcc: :one)
    end
    let!(:calendar_tcc_two) do
      find_or_create_calendar(year: Calendar.current_year,
                              semester: Calendar.current_semester, tcc: :two)
    end

    it 'finds calendar by tcc one' do
      results = described_class.call(tcc: :one, page: 1, term: calendar_tcc_one.year)
      expect(results.first.year).to eq(calendar_tcc_one.year)
    end

    it 'finds calendar by tcc two' do
      results = described_class.call(tcc: :two, page: 1, term: calendar_tcc_two.year)
      expect(results.first.year).to eq(calendar_tcc_two.year)
    end
  end
end
