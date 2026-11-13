require 'rails_helper'

RSpec.describe Orientations::StatusBadge do
  describe '.key_for' do
    it 'translates the displayed status into the persisted enum value' do
      status = Orientation.statuses.key('IN_PROGRESS')
      expect(described_class.key_for(status)).to eq('IN_PROGRESS')
    end

    it 'returns nil for an unknown status' do
      expect(described_class.key_for('inexistente')).to be_nil
    end
  end

  describe '.class_for' do
    {
      'APPROVED_TCC_ONE' => 'badge-approved-tcc-1',
      'APPROVED' => 'badge-approved',
      'IN_PROGRESS' => 'badge-in-progress',
      'CANCELED' => 'badge-canceled',
      'REPROVED_TCC_ONE' => 'badge-reproved-tcc-1',
      'REPROVED' => 'badge-reproved'
    }.each do |status_key, badge_class|
      it "returns #{badge_class} for #{status_key}" do
        expect(described_class.class_for(status_key)).to eq(badge_class)
      end
    end

    it 'falls back to the default class for an unmapped status' do
      expect(described_class.class_for('ABANDONED')).to eq('badge-secondary')
    end

    it 'falls back to the default class for nil' do
      expect(described_class.class_for(nil)).to eq('badge-secondary')
    end
  end

  it 'maps every status declared by the enum' do
    expect(described_class::MAPPINGS.keys).to match_array(Orientation.statuses.values)
  end
end
