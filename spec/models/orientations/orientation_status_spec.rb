require 'rails_helper'

RSpec.describe Orientation do
  subject(:orientation) { described_class.new }

  describe '#equal_status?' do
    it 'returns if the orientation is equal status?' do
      orientation = create(:orientation)
      expect(orientation.equal_status?('IN_PROGRESS')).to be(true)
    end
  end

  describe '#approved?' do
    it 'returns if the orientation is approved?' do
      orientation = create(:orientation_approved)
      expect(orientation.approved?).to be(true)
    end
  end

  describe '#canceled?' do
    it 'returns if the orientation is canceled?' do
      orientation = create(:orientation_canceled)
      expect(orientation.canceled?).to be(true)
    end
  end

  describe '#in_progress?' do
    it 'returns if the orientation is in progress?' do
      orientation = create(:orientation)
      expect(orientation.in_progress?).to be(true)
    end
  end

  describe '#can_be_canceled?' do
    it 'returns true' do
      professor = create(:responsible)
      orientation = create(:orientation_tcc_two)
      expect(orientation.can_be_canceled?(professor)).to be(true)
    end
  end

  describe '#by_status' do
    before do
      create(:orientation) # IN_PROGRESS
      create(:orientation_tcc_one_approved)
      create(:orientation_tcc_two_approved)
      create(:orientation_canceled)
    end

    it 'return in progress orientations' do
      expect(described_class.in_tcc_one.count).to eq(1)
    end

    it 'return approved in tcc one orientations' do
      expect(described_class.approved_tcc_one.count).to eq(1)
    end

    it 'return approved orientations' do
      expect(described_class.approved.count).to eq(1)
    end
  end
end
