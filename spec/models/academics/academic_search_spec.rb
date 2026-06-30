require 'rails_helper'

RSpec.describe Academic do
  describe '#search' do
    let(:academic) { create(:academic) }

    context 'when finds academic by attributes' do
      it 'returns academic by name' do
        results_search = described_class.search(academic.name)
        expect(academic.name).to eq(results_search.first.name)
      end

      it 'returns academic by email' do
        results_search = described_class.search(academic.email)
        expect(academic.email).to eq(results_search.first.email)
      end

      it 'returns academic by ra' do
        results_search = described_class.search(academic.ra)
        expect(academic.ra).to eq(results_search.first.ra)
      end
    end

    context 'when finds academic by name with accents' do
      it 'returns academic' do
        academic = create(:academic, name: 'João')
        results_search = described_class.search('Joao')
        expect(academic.name).to eq(results_search.first.name)
      end
    end

    context 'when finds academic by name on search term with accents' do
      it 'returns academic' do
        academic = create(:academic, name: 'Joao')
        results_search = described_class.search('João')
        expect(academic.name).to eq(results_search.first.name)
      end
    end

    context 'when finds academic by name ignoring the case sensitive' do
      it 'returns academic by attribute' do
        academic = create(:academic, name: 'Ana')
        results_search = described_class.search('an')
        expect(academic.name).to eq(results_search.first.name)
      end

      it 'returns academic by search term' do
        academic = create(:academic, name: 'ana')
        results_search = described_class.search('AN')
        expect(academic.name).to eq(results_search.first.name)
      end
    end

    context 'when returns academics ordered by name' do
      it 'returns ordered' do
        create_list(:academic, 10)
        academics_ordered = described_class.order(:name)
        academic = academics_ordered.first
        results_search = described_class.search.order(:name)
        expect(academic.name).to eq(results_search.first.name)
      end
    end
  end
end
