require 'rails_helper'

RSpec.describe Professor do
  subject(:professor) { described_class.new }

  describe '#search' do
    let(:responsible) { create(:responsible) }
    let(:professor) { create(:professor_tcc_one) }

    context 'when finds professor by attributes' do
      it 'returns professor by name' do
        results_search = described_class.search(professor.name)
        expect(professor.name).to eq(results_search.first.name)
      end

      it 'returns professor by email' do
        results_search = described_class.search(professor.email)
        expect(professor.email).to eq(results_search.first.email)
      end

      it 'returns professor by username' do
        results_search = described_class.search(professor.username)
        expect(professor.username).to eq(results_search.first.username)
      end

      it 'returns professor by role name' do
        results_search = described_class.search(responsible.roles.first.name)
        expect(responsible.name).to eq(results_search.first.name)
      end

      it 'returns professor by role identifier' do
        results_search = described_class.search(responsible.roles.first.identifier)
        expect(responsible.name).to eq(results_search.first.name)
      end
    end

    context 'when finds professor by name with accents' do
      it 'returns professor' do
        professor = create(:responsible, name: 'João')
        results_search = described_class.search('Joao')
        expect(professor.name).to eq(results_search.first.name)
      end
    end

    context 'when finds professor by name on search term with accents' do
      it 'returns professor' do
        professor = create(:responsible, name: 'Joao')
        results_search = described_class.search('João')
        expect(professor.name).to eq(results_search.first.name)
      end
    end

    context 'when finds professor by name ignoring the case sensitive' do
      it 'returns professor by attribute' do
        professor = create(:professor_tcc_one, name: 'Ana')
        results_search = described_class.search('an')
        expect(professor.name).to eq(results_search.first.name)
      end

      it 'returns professor by search term' do
        professor = create(:professor_tcc_one, name: 'ana')
        results_search = described_class.search('AN')
        expect(professor.name).to eq(results_search.first.name)
      end
    end

    context 'when returns professors ordered by name' do
      it 'returns ordered' do
        create_list(:professor_tcc_one, 10)
        professors_ordered = described_class.order(:name)
        professor = professors_ordered.first
        results_search = described_class.search.order(:name)
        expect(professor.name).to eq(results_search.first.name)
      end
    end
  end
end
