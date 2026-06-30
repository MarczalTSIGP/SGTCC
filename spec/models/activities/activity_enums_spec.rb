require 'rails_helper'

RSpec.describe Activity do
  describe '#human_tccs' do
    it 'returns the tccs' do
      tccs = described_class.tccs
      hash = {}
      tccs.each_key { |key| hash[I18n.t("enums.tcc.#{key}")] = key }

      expect(described_class.human_tccs).to eq(hash)
    end
  end

  describe '#human_tcc_one_identifiers' do
    it 'returns the tcc one identifiers' do
      hash = described_class.human_tcc_identifiers.first(2).to_h
      expect(described_class.human_tcc_one_identifiers).to eq(hash)
    end
  end

  describe '#identifier_translated' do
    let(:activity) { create(:activity) }

    it 'returns the identifier translated' do
      identifier_translated = I18n.t("enums.activity.identifiers.#{activity.identifier}")
      expect(activity.identifier_translated).to eq(identifier_translated)
    end
  end
end
