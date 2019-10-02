require 'rails_helper'

RSpec.describe Site, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe '#select_calendar_years' do
    before do
      create(:calendar, year: 2019)
      create(:calendar, year: 2018)
    end

    it 'returns the calendar years' do
      expect(Site.select_calendar_years).to eq(%w[2019 2018])
    end
  end
end
