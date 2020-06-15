require 'rails_helper'

RSpec.describe BaseActivity, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:tcc) }
    it { is_expected.to validate_presence_of(:identifier) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:base_activity_type) }
  end

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
        create_list(:base_activity, 30)
        base_activities_ordered = described_class.order(:name)
        base_activity = base_activities_ordered.first
        results_search = described_class.search.order(:name)
        expect(base_activity.name).to eq(results_search.first.name)
      end
    end
  end

  describe '#search_by_tcc_one' do
    let(:base_activity_tcc_one) { create(:base_activity_tcc_one) }
    let(:base_activity_tcc_two) { create(:base_activity_tcc_two) }

    context 'when finds base_activity by tcc one' do
      it 'returns base_activity by tcc one' do
        results_search = described_class.by_tcc_one(base_activity_tcc_one.name)
        expect(base_activity_tcc_one.name).to eq(results_search.first.name)
      end
    end

    context 'when finds base_activity by tcc two' do
      it 'returns base_activity by tcc two' do
        results_search = described_class.by_tcc_two(base_activity_tcc_two.name)
        expect(base_activity_tcc_two.name).to eq(results_search.first.name)
      end
    end
  end

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
end
