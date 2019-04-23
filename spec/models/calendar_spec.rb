require 'rails_helper'

RSpec.describe Calendar, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:year) }
    it { is_expected.to validate_presence_of(:tcc) }
    it { is_expected.to validate_presence_of(:semester) }
  end

  describe 'when year' do
    let(:calendar) { build(:calendar) }

    it 'is not valid' do
      invalid_year = '2eid'
      calendar.year = invalid_year
      expect(calendar.valid?).to((be false), "#{invalid_year.inspect} is not valid")
    end

    it 'is valid' do
      valid_year = '2019'
      calendar.year = valid_year
      expect(calendar.valid?).to((be true), "#{valid_year.inspect} is valid")
    end
  end

  describe 'when calendar is created' do
    it 'is clone base activities' do
      create_list(:base_activity_tcc_one, 3)
      calendar = create(:calendar_tcc_one)
      expect(calendar.activities).not_to be_empty
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:activities).dependent(:restrict_with_error) }
  end

  describe '#search' do
    let(:calendar) { create(:calendar) }

    context 'when finds calendar by attributes' do
      it 'returns calendar by year' do
        results_search = Calendar.search(calendar.year)
        expect(calendar.year).to eq(results_search.first.year)
      end
    end

    context 'when returns calendars ordered by year' do
      it 'returns ordered' do
        create_list(:calendar, 30)
        calendars_ordered = Calendar.order(year: :desc)
        calendar = calendars_ordered.first
        results_search = Calendar.search.order(year: :desc)
        expect(calendar.year).to eq(results_search.first.year)
      end
    end
  end

  describe '#current_by_tcc' do
    it 'returns the current calendar by tcc one' do
      calendar = create(:calendar_tcc_one)
      current_calendar = Calendar.current_by_tcc_one
      expect(calendar).to eq(current_calendar)
    end

    it 'returns the current calendar by tcc two' do
      calendar = create(:calendar_tcc_two)
      current_calendar = Calendar.current_by_tcc_two
      expect(calendar).to eq(current_calendar)
    end
  end

  describe '#year_with_semester' do
    it 'returns the calendar with (year/semester)' do
      calendar = create(:calendar)
      semester = I18n.t("enums.semester.#{calendar.semester}")
      year_with_semester = "#{calendar.year}/#{semester}"
      expect(calendar.year_with_semester).to eq(year_with_semester)
    end
  end

  describe '#select_data' do
    it 'returns the calendar data for select' do
      create_list(:calendar_tcc_one, 3)
      tcc_one = Calendar.tccs[:one]
      select_data = Calendar.select_data(tcc_one)
      expect_data = Calendar.where(tcc: tcc_one).order(created_at: :desc).map do |calendar|
        [calendar.id, calendar.year_with_semester]
      end
      expect(select_data).to eq(expect_data)
    end
  end

  describe '#human_semesters' do
    it 'returns the semesters' do
      semesters = Calendar.semesters
      hash = {}
      semesters.each_key { |key| hash[I18n.t("enums.semester.#{key}")] = key }

      expect(Calendar.human_semesters).to eq(hash)
    end
  end
end
