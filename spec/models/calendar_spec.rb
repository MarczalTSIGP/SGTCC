require 'rails_helper'

RSpec.describe Calendar, type: :model do
  describe 'validates' do
    subject(:calendar) { create(:calendar) }

    it { is_expected.to validate_presence_of(:year) }
    it { is_expected.to validate_presence_of(:tcc) }
    it { is_expected.to validate_presence_of(:semester) }

    it 'validates uniqueness of year' do
      msg = I18n.t('activerecord.errors.models.calendar.attributes.year')
      scp = [:semester, :tcc]
      expect(calendar).to validate_uniqueness_of(:year).with_message(msg)
                                                       .scoped_to(scp).case_insensitive
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:activities).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:academic_activities).through(:activities) }
    it { is_expected.to have_many(:orientation_calendars).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:orientations).through(:orientation_calendars) }
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

  describe '#search' do
    let(:calendar) { create(:current_calendar) }

    context 'when finds calendar by attributes' do
      it 'returns calendar by year' do
        results_search = described_class.search(calendar.year)
        expect(calendar.year).to eq(results_search.first.year)
      end
    end

    context 'when returns calendars ordered by year' do
      it 'returns ordered' do
        create_list(:calendar, 3)
        calendars_ordered = described_class.order(year: :desc)
        calendar = calendars_ordered.first
        results_search = described_class.search.order(year: :desc)
        expect(calendar.year).to eq(results_search.first.year)
      end
    end
  end

  describe '#search_by_tcc' do
    let(:calendar_tcc_one) { create(:current_calendar_tcc_one) }
    let(:calendar_tcc_two) { create(:current_calendar_tcc_two) }

    context 'when finds calendar by tcc one' do
      it 'returns calendar by tcc one' do
        results_search = described_class.search_by_tcc_one(1, calendar_tcc_one.year)
        expect(calendar_tcc_one.year).to eq(results_search.first.year)
      end
    end

    context 'when finds calendar by tcc two' do
      it 'returns calendar by tcc two' do
        results_search = described_class.search_by_tcc_two(1, calendar_tcc_two.year)
        expect(calendar_tcc_two.year).to eq(results_search.first.year)
      end
    end
  end

  describe '#current_by_tcc' do
    it 'returns the current calendar by tcc one' do
      calendar = create(:current_calendar_tcc_one)
      current_calendar = described_class.current_by_tcc_one
      expect(calendar).to eq(current_calendar)
    end

    it 'returns the current calendar by tcc two' do
      calendar = create(:current_calendar_tcc_two)
      current_calendar = described_class.current_by_tcc_two
      expect(calendar).to eq(current_calendar)
    end
  end

  describe '#year_with_semester' do
    it 'returns the calendar with (year/semester)' do
      calendar = create(:current_calendar)
      semester = I18n.t("enums.semester.#{calendar.semester}")
      year_with_semester = "#{calendar.year}/#{semester}"
      expect(calendar.year_with_semester).to eq(year_with_semester)
    end
  end

  describe '#year_with_semester_and_tcc' do
    it 'returns the calendar with (year/semester - TCC: tcc)' do
      calendar = create(:current_calendar)
      semester = I18n.t("enums.semester.#{calendar.semester}")
      tcc = I18n.t("enums.tcc.#{calendar.tcc}")
      year_with_semester_and_tcc = "#{calendar.year}/#{semester} - TCC: #{tcc}"
      expect(calendar.year_with_semester_and_tcc).to eq(year_with_semester_and_tcc)
    end
  end

  describe '#select_data' do
    it 'returns the calendar data for select' do
      create(:current_calendar_tcc_one)
      tcc_one = described_class.tccs[:one]
      expected_data = described_class.where(tcc: tcc_one).order(created_at: :desc).map do |calendar|
        [calendar.id, calendar.year_with_semester]
      end
      expect(described_class.select_data(tcc_one)).to eq(expected_data)
    end
  end

  describe '#select_for_orientation' do
    it 'returns the calendar data for orientation select' do
      create(:current_calendar_tcc_one)
      create(:current_calendar_tcc_two)
      expected_data = described_class.all.order({ year: :desc }, :tcc, :semester).map do |calendar|
        [calendar.id, calendar.year_with_semester_and_tcc]
      end
      expect(described_class.select_for_orientation).to eq(expected_data)
    end
  end

  describe '#next_semester' do
    it 'returns the next semester' do
      current_calendar = create(:current_calendar_tcc_one, semester: 1)
      next_calendar = create(:current_calendar_tcc_one, semester: 2)

      expect(described_class.next_semester(current_calendar)).to eq(next_calendar)
    end

    it 'returns the next year' do
      current_calendar = create(:current_calendar_tcc_one, semester: 2)
      next_year = current_calendar.year.to_i + 1
      next_calendar = create(:current_calendar_tcc_one, semester: 1, year: next_year)

      expect(described_class.next_semester(current_calendar)).to eq(next_calendar)
    end
  end

  describe '#previous_semester' do
    it 'returns the previous semester' do
      current_calendar = create(:current_calendar_tcc_one, semester: 2)
      previous_calendar = create(:current_calendar_tcc_one, semester: 1)

      expect(described_class.previous_semester(current_calendar)).to eq(previous_calendar)
    end

    it 'returns the previous year' do
      current_calendar = create(:current_calendar_tcc_one, semester: 1)
      previous_year = current_calendar.year.to_i - 1
      previous_calendar = create(:current_calendar_tcc_one, semester: 2, year: previous_year)

      expect(described_class.previous_semester(current_calendar)).to eq(previous_calendar)
    end
  end

  describe '#human_semesters' do
    it 'returns the semesters' do
      semesters = described_class.semesters
      hash = {}
      semesters.each_key { |key| hash[I18n.t("enums.semester.#{key}")] = key }
      expect(described_class.human_semesters).to eq(hash)
    end
  end

  describe '#human_tccs' do
    it 'returns the tccs' do
      tccs = described_class.tccs
      hash = {}
      tccs.each_key { |key| hash[I18n.t("enums.tcc.#{key}")] = key }
      expect(described_class.human_tccs).to eq(hash)
    end
  end

  describe '#current_by_tcc_one?' do
    it 'returns the value if the calendar is the current by tcc one' do
      calendar = create(:current_calendar_tcc_one)
      expect(described_class.current_by_tcc_one?(calendar)).to eq(true)
    end
  end

  describe '#current_by_tcc_two?' do
    it 'returns the value if the calendar is the current by tcc two' do
      calendar = create(:current_calendar_tcc_two)
      expect(described_class.current_by_tcc_two?(calendar)).to eq(true)
    end
  end

  describe '#current_calendar?' do
    it 'returns true for the current calendar' do
      calendar = create(:current_calendar_tcc_two)
      expect(described_class.current_calendar?(calendar)).to eq(true)
    end

    it 'returns false for the current calendar' do
      calendar = create(:calendar)
      expect(described_class.current_calendar?(calendar)).to eq(false)
    end
  end

  describe '#by_year_and_tcc' do
    context 'when returns the calendar by first year and first semester' do
      let!(:calendar_semester_one) { create(:current_calendar_tcc_two, semester: 'one') }

      it 'returns the calendar' do
        expect(described_class.by_first_year_and_tcc('two')).to eq(calendar_semester_one)
      end
    end

    context 'when returns the calendar by first year and second semester' do
      let!(:calendar_semester_two) { create(:current_calendar_tcc_two, semester: 'two') }

      it 'returns the calendar' do
        expect(described_class.by_first_year_and_tcc('two')).to eq(calendar_semester_two)
      end
    end
  end

  describe '#approved_orientations_report' do
    let!(:first_calendar) { create(:current_calendar_tcc_two, semester: 'one') }
    let!(:second_calendar) { create(:current_calendar_tcc_two, semester: 'two') }

    let(:calendars) { [first_calendar, second_calendar] }
    let(:status) { 'APPROVED' }

    it 'returns the list of approved orientations' do
      years = []
      total = []

      calendars.each do |calendar|
        years.push(calendar.year_with_semester)
        total.push(calendar.orientations.where(status: status).size)
      end

      report = { years: years, total: total }
      expect(described_class.orientations_report_by_status(status)).to eq(report)
    end
  end

  describe '#start_date' do
    let(:current_month) { Date.current.month }
    let(:current_year) { Date.current.year }

    context 'when current semester is one' do
      before { allow(described_class).to receive(:current_semester).and_return('one') }

      it 'returns the start date for the current semester (semester one)' do
        expected_date = Date.parse("1/1/#{current_year}")
        expect(described_class.start_date).to eq(expected_date)
      end
    end

    context 'when current semester is not one' do
      before { allow(described_class).to receive(:current_semester).and_return('two') }

      it 'returns the start date for the current semester (semester two)' do
        expected_date = Date.parse("1/8/#{current_year}")
        expect(described_class.start_date).to eq(expected_date)
      end
    end
  end
end
