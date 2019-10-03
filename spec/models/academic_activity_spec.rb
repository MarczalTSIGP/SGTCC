require 'rails_helper'

RSpec.describe AcademicActivity, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:summary) }
    it { is_expected.to validate_presence_of(:pdf) }
  end

  describe '#update_judgment' do
    let(:academic_activity) { create(:academic_activity) }

    it 'returns true' do
      expect(academic_activity.update_judgment).to eq(true)
    end
  end
end
