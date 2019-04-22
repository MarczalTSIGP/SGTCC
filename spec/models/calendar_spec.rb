require 'rails_helper'

RSpec.describe Calendar, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:year) }
    it { is_expected.to validate_presence_of(:tcc) }
    it { is_expected.to validate_presence_of(:semester) }
  end

  describe 'validates year' do
    let(:calendar) { build(:calendar) }

    it 'when year is not valid' do
      invalid_year = '2eid'
      calendar.year = invalid_year
      expect(calendar.valid?).to((be false), "#{invalid_year.inspect} is not valid")
    end

    it 'when year is valid' do
      valid_year = '2019'
      calendar.year = valid_year
      expect(calendar.valid?).to((be true), "#{valid_year.inspect} is valid")
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:activities).dependent(:restrict_with_error) }
  end
end
