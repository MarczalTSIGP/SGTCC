require 'rails_helper'

RSpec.describe BaseActivity do
  describe '#search' do
    let(:base_activity) { create(:base_activity) }

    context 'when finds base_activity by attributes' do
      it 'returns base activity by name' do
        results_search = described_class.search(base_activity.name)
        expect(base_activity.name).to eq(results_search.first.name)
      end

      it 'returns base activity by base activity type name' do
        base_activity_type_name = base_activity.base_activity_type.name
        results_search = described_class.search(base_activity_type_name)
        expect(base_activity_type_name).to eq(results_search.first.base_activity_type.name)
      end
    end

    context 'when finds base_activity by name with accents' do
      it 'returns base_activity' do
        base_activity = create(:base_activity, name: 'Atividade do João')
        results_search = described_class.search('Atividade do Joao')
        expect(base_activity.name).to eq(results_search.first.name)
      end
    end

    context 'when finds base_activity by name on search term with accents' do
      it 'returns base_activity' do
        base_activity = create(:base_activity, name: 'Atividade do Joao')
        results_search = described_class.search('Atividade do João')
        expect(base_activity.name).to eq(results_search.first.name)
      end
    end

    context 'when finds base_activity by name ignoring the case sensitive' do
      it 'returns base_activity by attribute' do
        base_activity = create(:base_activity, name: 'Ativ')
        results_search = described_class.search('ativ')
        expect(base_activity.name).to eq(results_search.first.name)
      end

      it 'returns base_activity by search term' do
        base_activity = create(:base_activity, name: 'ativ')
        results_search = described_class.search('ATIV')
        expect(base_activity.name).to eq(results_search.first.name)
      end
    end

    context 'when returns base_activitys ordered by name' do
      it 'returns ordered' do
        create_list(:base_activity, 10)
        base_activities_ordered = described_class.order(:name)
        base_activity = base_activities_ordered.first
        results_search = described_class.search.order(:name)
        expect(base_activity.name).to eq(results_search.first.name)
      end
    end
  end
end
