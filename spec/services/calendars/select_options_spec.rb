require 'rails_helper'

RSpec.describe Calendars::SelectOptions do
  describe '.for_tcc' do
    let!(:older) { create(:calendar, :tcc_one, year: '2034', semester: :one) }
    let!(:newer_first_semester) { create(:calendar, :tcc_one, year: '2035', semester: :one) }
    let!(:newer_second_semester) { create(:calendar, :tcc_one, year: '2035', semester: :two) }
    let!(:other_tcc) { create(:calendar, :tcc_two, year: '2036', semester: :one) }

    let(:ids) { described_class.for_tcc(:one).map(&:first) }

    it 'orders the same year by semester ascending' do
      expect(ids.index(newer_first_semester.id)).to be < ids.index(newer_second_semester.id)
    end

    it 'orders by year descending' do
      expect(ids.index(newer_second_semester.id)).to be < ids.index(older.id)
    end

    it 'excludes calendars from other tccs' do
      expect(ids).not_to include(other_tcc.id)
    end

    it 'labels each pair with year_with_semester' do
      results = described_class.for_tcc(:one)
      expect(results).to include([newer_first_semester.id, newer_first_semester.year_with_semester])
    end
  end

  describe '.for_orientation' do
    let!(:calendar_one) { create(:calendar, :tcc_one, year: '2033', semester: :one) }
    let!(:calendar_two) { create(:calendar, :tcc_two, year: '2033', semester: :one) }
    let!(:older) { create(:calendar, :tcc_one, year: '2032', semester: :one) }

    let(:ids) { described_class.for_orientation.map(&:first) }

    it 'orders the same year by tcc ascending' do
      expect(ids.index(calendar_one.id)).to be < ids.index(calendar_two.id)
    end

    it 'orders by year descending' do
      expect(ids.index(calendar_two.id)).to be < ids.index(older.id)
    end

    it 'labels each pair with year_with_semester_and_tcc' do
      results = described_class.for_orientation
      expect(results).to include([calendar_one.id, calendar_one.year_with_semester_and_tcc])
    end
  end
end
