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

  describe '#recent' do
    let(:professor) { create(:professor) }
    let(:orientation) { create(:orientation, advisor: professor) }
    let(:meetings) { [] }

    before do
      5.times do
        meetings.push(create(:meeting, orientation: orientation))
      end
    end

    context 'when returns meetings order by academics name and date' do
      it 'returns the meetings ordered' do
        order_by = 'academics.name ASC, meetings.date DESC'
        meetings_ordered = described_class.joins(orientation: [:academic]).order(order_by)
        expect(professor.meetings.recent).to match_array(meetings_ordered)
      end
    end
  end
end
