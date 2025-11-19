require 'rails_helper'

RSpec.describe Calendar, type: :model do
  describe 'validations' do
    subject(:calendar) { create(:calendar) }

    it { is_expected.to validate_presence_of(:year) }
    it { is_expected.to validate_presence_of(:tcc) }
    it { is_expected.to validate_presence_of(:semester) }

    it 'validates uniqueness of year scoped to semester and tcc' do
      msg = I18n.t('activerecord.errors.models.calendar.attributes.year')
      scp = [:semester, :tcc]
      expect(calendar).to validate_uniqueness_of(:year).with_message(msg).scoped_to(scp).case_insensitive
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
    it 'is invalid when end_date is before start_date' do
      calendar = build(:calendar, start_date: Date.today, end_date: Date.yesterday)
      expect(calendar).not_to be_valid
      expect(calendar.errors[:end_date]).to include('deve ser posterior à data de início')
    end

  it 'is valid when end_date is after start_date' do
    start_date = Date.today
    end_date   = start_date + 1.day
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
