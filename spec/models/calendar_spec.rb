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
end
