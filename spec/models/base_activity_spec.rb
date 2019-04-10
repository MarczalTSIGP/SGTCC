require 'rails_helper'

RSpec.describe BaseActivity, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:tcc) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:base_activity_type) }
  end

  describe '#search' do
    let(:base_activity) { create(:base_activity) }

    context 'when finds base_activity by attributes' do
      it 'returns base_activity by name' do
        results_search = BaseActivity.search(base_activity.name)
        expect(base_activity.name).to eq(results_search.first.name)
      end
    end

    context 'when finds base_activity by name with accents' do
      it 'returns base_activity' do
        base_activity = create(:base_activity, name: 'Atividade do João')
        results_search = BaseActivity.search('Atividade do Joao')
        expect(base_activity.name).to eq(results_search.first.name)
      end
    end

    context 'when finds base_activity by name on search term with accents' do
      it 'returns base_activity' do
        base_activity = create(:base_activity, name: 'Atividade do Joao')
        results_search = BaseActivity.search('Atividade do João')
        expect(base_activity.name).to eq(results_search.first.name)
      end
    end

    context 'when finds base_activity by name ignoring the case sensitive' do
      it 'returns base_activity by attribute' do
        base_activity = create(:base_activity, name: 'Ativ')
        results_search = BaseActivity.search('ativ')
        expect(base_activity.name).to eq(results_search.first.name)
      end

      it 'returns base_activity by search term' do
        base_activity = create(:base_activity, name: 'ativ')
        results_search = BaseActivity.search('ATIV')
        expect(base_activity.name).to eq(results_search.first.name)
      end
    end

    context 'when returns base_activitys ordered by name' do
      it 'returns ordered' do
        create_list(:base_activity, 30)
        base_activities_ordered = BaseActivity.order(:name)
        base_activity = base_activities_ordered.first
        results_search = BaseActivity.search.order(:name)
        expect(base_activity.name). to eq(results_search.first.name)
      end
    end
  end
end
