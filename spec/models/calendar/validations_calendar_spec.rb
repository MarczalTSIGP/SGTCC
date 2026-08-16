require 'rails_helper'

RSpec.describe Calendar, type: :model do
  describe 'tcc enum persistence contract' do
    it 'keeps the persisted enum mapping unchanged' do
      expect(described_class.tccs).to eq({ 'one' => 1, 'two' => 2 })
    end

    it 'persists symbolic tcc assignments as the existing integer values' do
      tcc_one = create(:calendar, :tcc_one)
      tcc_two = create(:calendar, :tcc_two)

      expect(tcc_one.read_attribute_before_type_cast(:tcc)).to eq(1)
      expect(tcc_two.read_attribute_before_type_cast(:tcc)).to eq(2)
    end

    it 'reads previously persisted integer tcc values through the enum API' do
      tcc_one = create(:calendar)
      tcc_two = create(:calendar)

      # rubocop:disable Rails/SkipsModelValidations
      tcc_one.update_column(:tcc, 1)
      tcc_two.update_column(:tcc, 2)
      # rubocop:enable Rails/SkipsModelValidations

      expect(tcc_one.reload.tcc).to eq('one')
      expect(tcc_two.reload.tcc).to eq('two')
    end
  end

  describe 'semester enum persistence contract' do
    it 'keeps the persisted enum mapping unchanged' do
      expect(described_class.semesters).to eq({ 'one' => 1, 'two' => 2 })
    end

    it 'persists symbolic semester assignments as the existing integer values' do
      first_semester = create(:calendar, semester: :one)
      second_semester = create(:calendar, semester: :two)

      expect(first_semester.read_attribute_before_type_cast(:semester)).to eq(1)
      expect(second_semester.read_attribute_before_type_cast(:semester)).to eq(2)
    end

    it 'reads previously persisted integer semester values through the enum API' do
      first_semester = create(:calendar)
      second_semester = create(:calendar)

      # rubocop:disable Rails/SkipsModelValidations
      first_semester.update_column(:semester, 1)
      second_semester.update_column(:semester, 2)
      # rubocop:enable Rails/SkipsModelValidations

      expect(first_semester.reload.semester).to eq('one')
      expect(second_semester.reload.semester).to eq('two')
    end
  end

  describe 'validations' do
    subject(:calendar) { create(:calendar) }

    it { is_expected.to validate_presence_of(:year) }
    it { is_expected.to validate_presence_of(:tcc) }
    it { is_expected.to validate_presence_of(:semester) }

    it 'validates uniqueness of year scoped to semester and tcc' do
      msg = I18n.t('activerecord.errors.models.calendar.attributes.year')
      scp = [:semester, :tcc]
      expect(calendar).to validate_uniqueness_of(:year)
        .with_message(msg).scoped_to(scp).case_insensitive
    end

    it 'is invalid when start_date and end_date are nil and callback is skipped' do
      calendar = build(:calendar, start_date: nil, end_date: nil)
      allow(calendar).to receive(:set_dates)

      expect(calendar).not_to be_valid
      expect(calendar.errors[:start_date]).to be_present
      expect(calendar.errors[:end_date]).to be_present
    end
  end

  describe 'start_date and end_date' do
    it 'sets default dates for the first semester assigned with a symbol' do
      calendar = build(:calendar, year: '2036', semester: :one,
                                  start_date: nil, end_date: nil)

      calendar.valid?

      expect(calendar.start_date.to_date).to eq(Date.new(2036, 1, 1))
      expect(calendar.end_date.to_date).to eq(Date.new(2036, 6, 30))
    end

    it 'sets default dates for a second semester record reloaded from the database' do
      calendar = create(:calendar, year: '2036', semester: :two)
      reloaded_calendar = described_class.find(calendar.id)

      reloaded_calendar.start_date = nil
      reloaded_calendar.end_date = nil
      reloaded_calendar.valid?

      expect(reloaded_calendar.start_date.to_date).to eq(Date.new(2036, 7, 1))
      expect(reloaded_calendar.end_date.to_date).to eq(Date.new(2036, 12, 31))
    end

    it 'keeps dates provided explicitly by the user' do
      start_date = Date.new(2026, 2, 10)
      end_date = Date.new(2026, 5, 20)
      calendar = build(:calendar, year: '2036', semester: :one,
                                  start_date:, end_date:)

      calendar.valid?

      expect(calendar.start_date.to_date).to eq(start_date)
      expect(calendar.end_date.to_date).to eq(end_date)
    end

    it 'is invalid when end_date is before start_date' do
      calendar = build(:calendar, start_date: Time.zone.today, end_date: Date.yesterday)
      expect(calendar).not_to be_valid
      expect(calendar.errors[:end_date]).to include('deve ser posterior à data de início')
    end

    it 'is valid when end_date is after start_date' do
      start_date = Time.zone.today
      end_date = start_date + 1.day
      calendar = build(:calendar, start_date: start_date, end_date: end_date)
      expect(calendar).to be_valid
    end
  end

  describe 'year validation' do
    it 'is invalid for non-numeric year' do
      calendar = build(:calendar, year: '2eid')
      expect(calendar).not_to be_valid
    end

    it 'is valid for numeric year' do
      calendar = build(:calendar, year: '2019')
      expect(calendar).to be_valid
    end
  end
end
