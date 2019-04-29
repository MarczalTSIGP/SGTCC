require 'rails_helper'

RSpec.describe Orientation, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:calendar) }
    it { is_expected.to belong_to(:academic) }
    it { is_expected.to belong_to(:advisor).class_name(Professor.to_s) }
    it { is_expected.to belong_to(:institution) }
  end

  describe '#search' do
    let(:orientation) { create(:orientation) }

    context 'when finds orientation by attributes' do
      it 'returns orientation by title' do
        results_search = Orientation.search(orientation.title)
        expect(orientation.title).to eq(results_search.first.title)
      end
    end

    context 'when finds orientation by title with accents' do
      it 'returns orientation' do
        orientation = create(:orientation, title: 'Sistema de Gestão')
        results_search = Orientation.search('Sistema de Gestao')
        expect(orientation.title).to eq(results_search.first.title)
      end
    end

    context 'when finds orientation by title on search term with accents' do
      it 'returns orientation' do
        orientation = create(:orientation, title: 'Sistema de Gestao')
        results_search = Orientation.search('Sistema de Gestão')
        expect(orientation.title).to eq(results_search.first.title)
      end
    end

    context 'when finds orientation by title ignoring the case sensitive' do
      it 'returns orientation by attribute' do
        orientation = create(:orientation, title: 'Sistema')
        results_search = Orientation.search('sistema')
        expect(orientation.title).to eq(results_search.first.title)
      end

      it 'returns orientation by search term' do
        orientation = create(:orientation, title: 'sistema')
        results_search = Orientation.search('SISTEMA')
        expect(orientation.title).to eq(results_search.first.title)
      end
    end

    context 'when returns orientations ordered by title' do
      it 'returns ordered' do
        create_list(:orientation, 30)
        orientations_ordered = Orientation.order(:title)
        orientation = orientations_ordered.first
        results_search = Orientation.search.order(:title)
        expect(orientation.title). to eq(results_search.first.title)
      end
    end
  end
end
