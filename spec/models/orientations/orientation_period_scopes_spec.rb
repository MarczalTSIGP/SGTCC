require 'rails_helper'

RSpec.describe Orientation do
  let(:in_progress) { described_class.statuses.key('IN_PROGRESS') }
  let(:canceled) { described_class.statuses.key('CANCELED') }

  describe '.tcc_one' do
    before do
      create(:orientation, :tcc_one, :current)
      create(:orientation, :tcc_two, :current)
    end

    it 'returns only orientations from a tcc one calendar' do
      expect(described_class.tcc_one(nil).count).to eq(1)
    end

    it 'filters by status when it is provided' do
      create(:orientation, :tcc_one, :current, status: canceled)

      expect(described_class.tcc_one(canceled).count).to eq(1)
    end

    it 'ignores a blank status' do
      expect(described_class.tcc_one('').count).to eq(described_class.tcc_one(nil).count)
    end

    it 'filters by year and semester when they are provided' do
      calendar = described_class.tcc_one(nil).first.current_calendar

      expect(described_class.tcc_one(nil, calendar.year, calendar.semester).count).to eq(1)
      expect(described_class.tcc_one(nil, calendar.year.to_i - 10).count).to eq(0)
    end
  end

  describe '.tcc_two' do
    before do
      create(:orientation, :tcc_one, :current)
      create(:orientation, :tcc_two, :current)
    end

    it 'returns only orientations from a tcc two calendar' do
      expect(described_class.tcc_two(nil).count).to eq(1)
    end

    it 'filters by status when it is provided' do
      expect(described_class.tcc_two(in_progress).count).to eq(1)
      expect(described_class.tcc_two(canceled).count).to eq(0)
    end
  end

  describe '.current_tcc_one' do
    it 'returns only orientations from the current tcc one calendar' do
      create(:orientation, :tcc_one, :current)
      create(:orientation, :tcc_one, :previous)

      expect(described_class.current_tcc_one.count).to eq(1)
    end

    it 'ignores a blank status' do
      create(:orientation, :tcc_one, :current)

      expect(described_class.current_tcc_one('').count).to eq(1)
    end

    it 'filters by status when it is provided' do
      create(:orientation, :tcc_one, :current)

      expect(described_class.current_tcc_one(in_progress).count).to eq(1)
      expect(described_class.current_tcc_one(canceled).count).to eq(0)
    end
  end

  describe '.current_tcc_two' do
    it 'returns only orientations from the current tcc two calendar' do
      create(:orientation, :tcc_two, :current)
      create(:orientation, :tcc_two, :previous)

      expect(described_class.current_tcc_two.count).to eq(1)
    end
  end

  describe 'chaining from a relation' do
    it 'keeps the conditions already applied to the relation' do
      kept = create(:orientation, :tcc_one, :current)
      create(:orientation, :tcc_one, :current)

      expect(described_class.where(id: kept.id).tcc_one(nil).count).to eq(1)
      expect(described_class.where(id: kept.id).current_tcc_one.count).to eq(1)
    end
  end
end
