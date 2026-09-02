require 'rails_helper'

RSpec.describe Calendar, type: :model do
  describe '.current_semester' do
    it 'defaults to the second semester in July' do
      travel_to Date.new(2026, 7, 2) do
        allow(described_class).to receive_messages(current_range_calendar: nil,
                                                   latest_calendar: nil)

        expect(described_class.current_semester).to eq(2)
      end
    end

    it 'defaults to the first semester in June' do
      travel_to Date.new(2026, 6, 30) do
        allow(described_class).to receive_messages(current_range_calendar: nil,
                                                   latest_calendar: nil)

        expect(described_class.current_semester).to eq(1)
      end
    end
  end

  describe '#current_by_tcc' do
    it 'returns current by tcc one' do
      calendar = find_or_create_calendar(year: described_class.current_year,
                                         semester: described_class.current_semester, tcc: :one)
      expect(described_class.current_by_tcc_one).to eq(calendar)
    end

    it 'returns current by tcc two' do
      calendar = find_or_create_calendar(year: described_class.current_year,
                                         semester: described_class.current_semester, tcc: :two)
      expect(described_class.current_by_tcc_two).to eq(calendar)
    end
  end

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
