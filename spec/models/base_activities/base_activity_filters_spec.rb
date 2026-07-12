require 'rails_helper'

RSpec.describe BaseActivity do
  describe '#search_by_tcc_one' do
    let(:base_activity_one) { create(:base_activity, :tcc_one) }
    let(:base_activity_two) { create(:base_activity, :tcc_two) }

    context 'when finds base_activity by tcc one' do
      it 'returns base_activity by tcc one' do
        results_search = described_class.by_tcc_one(base_activity_one.name)
        expect(base_activity_one.name).to eq(results_search.first.name)
      end
    end

    context 'when finds base_activity by tcc two' do
      it 'returns base_activity by tcc two' do
        results_search = described_class.by_tcc_two(base_activity_two.name)
        expect(base_activity_two.name).to eq(results_search.first.name)
      end
    end
  end
end
