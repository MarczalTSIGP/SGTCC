require 'rails_helper'

RSpec.describe Calendar, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:year) }
    it { is_expected.to validate_presence_of(:tcc) }
    it { is_expected.to validate_presence_of(:semester) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:activities).dependent(:restrict_with_error) }
  end

  context 'when search by param' do
    let!(:calendar) { create(:calendar_tcc_one) }

    it 'when calendar is searched by param (year/semester)' do
      result = Calendar.search_by_param(Calendar.tccs[:one], calendar.year_with_semester)
      expect(result.id).to eq(calendar.id)
    end
  end
end
