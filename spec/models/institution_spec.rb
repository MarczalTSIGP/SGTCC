require 'rails_helper'

RSpec.describe Institution, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:trade_name) }
    it { is_expected.to validate_presence_of(:cnpj) }
    it { is_expected.to validate_uniqueness_of(:cnpj).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:external_member) }
  end

  describe '#search' do
    let(:institution) { create(:institution) }
    let(:search_fields) do
      { name: { unaccent: true },
        trade_name: { unaccent: true },
        cnpj: { unaccent: false } }
    end

    context 'when finds institution by attributes' do
      it 'returns institution by name' do
        results_search = Institution.search(institution.name, search_fields)
        expect(institution.name).to eq(results_search.first.name)
      end

      it 'returns institution by trade name' do
        results_search = Institution.search(institution.trade_name, search_fields)
        expect(institution.trade_name).to eq(results_search.first.trade_name)
      end

      it 'returns institution by cnpj' do
        results_search = Institution.search(institution.cnpj, search_fields)
        expect(institution.cnpj).to eq(results_search.first.cnpj)
      end
    end

    context 'when finds institution by name with accents' do
      it 'returns institution' do
        institution = create(:institution, name: 'Instituição')
        results_search = Institution.search('Instituicao', search_fields)
        expect(institution.name).to eq(results_search.first.name)
      end
    end

    context 'when finds institution by name on search term with accents' do
      it 'returns institution' do
        institution = create(:institution, name: 'Instituicao')
        results_search = Institution.search('Instituição', search_fields)
        expect(institution.name).to eq(results_search.first.name)
      end
    end

    context 'when finds institution by name ignoring the case sensitive' do
      it 'returns institution by attribute' do
        institution = create(:institution, name: 'Ins')
        results_search = Institution.search('ins', search_fields)
        expect(institution.name).to eq(results_search.first.name)
      end

      it 'returns institution by search term' do
        institution = create(:institution, name: 'ins')
        results_search = Institution.search('INS', search_fields)
        expect(institution.name).to eq(results_search.first.name)
      end
    end

    context 'when returns institutions ordered by name' do
      it 'returns ordered' do
        create_list(:institution, 30)
        institutions_ordered = Institution.order(:name)
        institution = institutions_ordered.first
        results_search = Institution.search
        expect(institution.name). to eq(results_search.first.name)
      end
    end
  end
end
