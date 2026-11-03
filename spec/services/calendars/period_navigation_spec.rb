require 'rails_helper'

RSpec.describe Calendars::PeriodNavigation do
  describe '.previous_semester' do
    it 'returns the first semester of the same year from the second semester' do
      current = create(:calendar, :tcc_one, year: '2036', semester: :two)
      previous_calendar = create(:calendar, :tcc_one, year: '2036', semester: :one)

      expect(described_class.previous_semester(current)).to eq(previous_calendar)
    end

    it 'returns the second semester of the previous year from the first semester' do
      current = create(:calendar, :tcc_one, year: '2036', semester: :one)
      previous_calendar = create(:calendar, :tcc_one, year: '2035', semester: :two)

      expect(described_class.previous_semester(current)).to eq(previous_calendar)
    end

    it 'returns nil when the previous calendar does not exist' do
      current = create(:calendar, :tcc_one, year: '2036', semester: :one)

      expect(described_class.previous_semester(current)).to be_nil
    end

    it 'returns nil when the calendar argument is nil' do
      expect(described_class.previous_semester(nil)).to be_nil
    end
  end

  describe '.next_semester' do
    it 'returns the second semester of the same year from the first semester' do
      current = create(:calendar, :tcc_one, year: '2036', semester: :one)
      next_calendar = create(:calendar, :tcc_one, year: '2036', semester: :two)

      expect(described_class.next_semester(current)).to eq(next_calendar)
    end

    it 'returns the first semester of the next year from the second semester' do
      current = create(:calendar, :tcc_one, year: '2036', semester: :two)
      next_calendar = create(:calendar, :tcc_one, year: '2037', semester: :one)

      expect(described_class.next_semester(current)).to eq(next_calendar)
    end

    it 'returns nil when the next calendar does not exist' do
      current = create(:calendar, :tcc_one, year: '2036', semester: :two)

      expect(described_class.next_semester(current)).to be_nil
    end
  end

  describe '.next_semester_tcc_two' do
    it 'returns the same year TCC II calendar from TCC I first semester' do
      current = create(:calendar, :tcc_one, year: '2036', semester: :one)
      next_calendar = create(:calendar, :tcc_two, year: '2036', semester: :two)

      expect(described_class.next_semester_tcc_two(current)).to eq(next_calendar)
    end

    it 'returns the next year TCC II calendar from TCC I second semester' do
      current = create(:calendar, :tcc_one, year: '2036', semester: :two)
      next_calendar = create(:calendar, :tcc_two, year: '2037', semester: :one)

      expect(described_class.next_semester_tcc_two(current)).to eq(next_calendar)
    end

    it 'uses regular next semester navigation for TCC II calendars' do
      current = create(:calendar, :tcc_two, year: '2036', semester: :one)
      next_calendar = create(:calendar, :tcc_two, year: '2036', semester: :two)

      expect(described_class.next_semester_tcc_two(current)).to eq(next_calendar)
    end

    it 'returns nil when the next TCC II calendar does not exist' do
      current = create(:calendar, :tcc_one, year: '2036', semester: :one)

      expect(described_class.next_semester_tcc_two(current)).to be_nil
    end
  end
end
