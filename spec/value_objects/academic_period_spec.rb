require 'rails_helper'

RSpec.describe AcademicPeriod do
  def period(year, semester)
    described_class.new(year:, semester:)
  end

  describe 'navigation' do
    it 'goes from the first to the second semester of the same year' do
      expect(period(2036, 1).next).to eq(period(2036, 2))
    end

    it 'goes from the second semester to the first of the next year' do
      expect(period(2036, 2).next).to eq(period(2037, 1))
    end

    it 'goes back from the second to the first semester of the same year' do
      expect(period(2036, 2).previous).to eq(period(2036, 1))
    end

    it 'goes back from the first semester to the second of the previous year' do
      expect(period(2036, 1).previous).to eq(period(2035, 2))
    end

    it 'returns new objects and keeps the original unchanged' do
      original = period(2036, 2)
      original.next

      expect(original).to eq(period(2036, 2))
      expect(original).to be_frozen
    end
  end

  describe 'value semantics' do
    it 'is equal by value and usable as a hash key' do
      expect({ period(2036, 1) => :x }[period(2036, 1)]).to eq(:x)
    end

    it 'orders by year and then semester' do
      expect([period(2037, 1), period(2036, 2), period(2036, 1)].sort)
        .to eq([period(2036, 1), period(2036, 2), period(2037, 1)])
    end

    it 'normalizes a string year' do
      expect(period('2036', 1)).to eq(period(2036, 1))
    end

    it 'rejects an invalid semester' do
      expect { period(2036, 3) }.to raise_error(ArgumentError, /Unsupported semester/)
    end
  end

  describe 'construction' do
    it 'builds from a calendar using the persisted enum' do
      calendar = build(:calendar, year: '2036', semester: :two)

      expect(described_class.from_calendar(calendar)).to eq(period(2036, 2))
    end

    it 'builds from a date: January to June is the first semester' do
      expect(described_class.from_date(Date.new(2036, 6, 30))).to eq(period(2036, 1))
      expect(described_class.from_date(Date.new(2036, 7, 1))).to eq(period(2036, 2))
    end
  end

  describe 'dates and labels' do
    it 'spans January to June in the first semester' do
      expect([period(2036, 1).first_day, period(2036, 1).last_day])
        .to eq([Date.new(2036, 1, 1), Date.new(2036, 6, 30)])
    end

    it 'spans July to December in the second semester' do
      expect([period(2036, 2).first_day, period(2036, 2).last_day])
        .to eq([Date.new(2036, 7, 1), Date.new(2036, 12, 31)])
    end

    it 'maps to the calendar enum key and a readable label' do
      expect([period(2036, 2).semester_key, period(2036, 2).to_s]).to eq([:two, '2036/2'])
    end
  end
end
