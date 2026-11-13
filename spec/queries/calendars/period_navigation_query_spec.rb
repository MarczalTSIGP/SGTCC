require 'rails_helper'

RSpec.describe Calendars::PeriodNavigationQuery do
  describe 'direction: :previous' do
    it 'returns the first semester of the same year from the second semester' do
      current = create(:calendar, :tcc_one, year: '2036', semester: :two)
      previous_calendar = create(:calendar, :tcc_one, year: '2036', semester: :one)

      expect(described_class.call(current, direction: :previous)).to eq(previous_calendar)
    end

    it 'returns the second semester of the previous year from the first semester' do
      current = create(:calendar, :tcc_one, year: '2036', semester: :one)
      previous_calendar = create(:calendar, :tcc_one, year: '2035', semester: :two)

      expect(described_class.call(current, direction: :previous)).to eq(previous_calendar)
    end

    it 'returns nil when the previous calendar does not exist' do
      current = create(:calendar, :tcc_one, year: '2036', semester: :one)

      expect(described_class.call(current, direction: :previous)).to be_nil
    end

    it 'returns nil when the calendar argument is nil' do
      expect(described_class.call(nil, direction: :previous)).to be_nil
    end
  end

  describe 'direction: :next' do
    it 'returns the second semester of the same year from the first semester' do
      current = create(:calendar, :tcc_one, year: '2036', semester: :one)
      next_calendar = create(:calendar, :tcc_one, year: '2036', semester: :two)

      expect(described_class.call(current, direction: :next)).to eq(next_calendar)
    end

    it 'returns the first semester of the next year from the second semester' do
      current = create(:calendar, :tcc_one, year: '2036', semester: :two)
      next_calendar = create(:calendar, :tcc_one, year: '2037', semester: :one)

      expect(described_class.call(current, direction: :next)).to eq(next_calendar)
    end

    it 'returns nil when the next calendar does not exist' do
      current = create(:calendar, :tcc_one, year: '2036', semester: :two)

      expect(described_class.call(current, direction: :next)).to be_nil
    end
  end

  describe 'direction: :next_tcc_two' do
    it 'returns the same year TCC II calendar from TCC I first semester' do
      current = create(:calendar, :tcc_one, year: '2036', semester: :one)
      next_calendar = create(:calendar, :tcc_two, year: '2036', semester: :two)

      expect(described_class.call(current, direction: :next_tcc_two)).to eq(next_calendar)
    end

    it 'returns the next year TCC II calendar from TCC I second semester' do
      current = create(:calendar, :tcc_one, year: '2036', semester: :two)
      next_calendar = create(:calendar, :tcc_two, year: '2037', semester: :one)

      expect(described_class.call(current, direction: :next_tcc_two)).to eq(next_calendar)
    end

    it 'uses regular next semester navigation for TCC II calendars' do
      current = create(:calendar, :tcc_two, year: '2036', semester: :one)
      next_calendar = create(:calendar, :tcc_two, year: '2036', semester: :two)

      expect(described_class.call(current, direction: :next_tcc_two)).to eq(next_calendar)
    end

    it 'returns nil when the next TCC II calendar does not exist' do
      current = create(:calendar, :tcc_one, year: '2036', semester: :one)

      expect(described_class.call(current, direction: :next_tcc_two)).to be_nil
    end
  end

  it 'raises for an unsupported direction' do
    expect { described_class.call(build(:calendar), direction: :sideways) }
      .to raise_error(ArgumentError, /sideways/)
  end
end
