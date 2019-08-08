require 'rails_helper'

RSpec.describe Meeting, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:orientation) }
  end

  describe '#update_viewed' do
    let(:meeting) { create(:meeting) }

    it 'returns true' do
      expect(meeting.update_viewed).to eq(true)
    end
  end

  describe '#can_update?' do
    let(:meeting) { create(:meeting) }

    context 'when returns true' do
      it 'returns true' do
        expect(meeting.can_update?).to eq(true)
      end
    end

    context 'when returns false' do
      before do
        meeting.update(viewed: true)
      end

      it 'returns false' do
        expect(meeting.can_update?).to eq(false)
      end
    end
  end
end
