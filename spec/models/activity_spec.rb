require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:activity_type) }
  end

  describe '#search' do
    let(:activity) { create(:activity) }

    context 'when finds activity by attributes' do
      it 'returns activity by name' do
        results_search = Activity.search(activity.name)
        expect(activity.name).to eq(results_search.first.name)
      end
    end

    context 'when finds activity by name with accents' do
      it 'returns activity' do
        activity = create(:activity, name: 'Atividade do João')
        results_search = Activity.search('Atividade do Joao')
        expect(activity.name).to eq(results_search.first.name)
      end
    end

    context 'when finds activity by name on search term with accents' do
      it 'returns activity' do
        activity = create(:activity, name: 'Atividade do Joao')
        results_search = Activity.search('Atividade do João')
        expect(activity.name).to eq(results_search.first.name)
      end
    end

    context 'when finds activity by name ignoring the case sensitive' do
      it 'returns activity by attribute' do
        activity = create(:activity, name: 'Ativ')
        results_search = Activity.search('ativ')
        expect(activity.name).to eq(results_search.first.name)
      end

      it 'returns activity by search term' do
        activity = create(:activity, name: 'ativ')
        results_search = Activity.search('ATIV')
        expect(activity.name).to eq(results_search.first.name)
      end
    end

    context 'when returns activitys ordered by name' do
      it 'returns ordered' do
        create_list(:activity, 30)
        activitys_ordered = Activity.order(:name)
        activity = activitys_ordered.first
        results_search = Activity.search.order(:name)
        expect(activity.name). to eq(results_search.first.name)
      end
    end
  end

end
