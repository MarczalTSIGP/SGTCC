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

    context 'when finds institution by attributes' do
      it 'returns institution by name' do
        results_search = Institution.search(institution.name)
        expect(institution.name).to eq(results_search.first.name)
      end

      it 'returns institution by trade name' do
        results_search = Institution.search(institution.trade_name)
        expect(institution.trade_name).to eq(results_search.first.trade_name)
      end

      it 'returns institution by cnpj' do
        results_search = Institution.search(institution.cnpj)
        expect(institution.cnpj).to eq(results_search.first.cnpj)
      end
    end

    context 'when finds institution by name with accents' do
      it 'returns institution' do
        institution = create(:institution, name: 'Instituição')
        results_search = Institution.search('Instituicao')
        expect(institution.name).to eq(results_search.first.name)
      end
    end

    context 'when finds institution by name on search term with accents' do
      it 'returns institution' do
        institution = create(:institution, name: 'Instituicao')
        results_search = Institution.search('Instituição')
        expect(institution.name).to eq(results_search.first.name)
      end
    end

    context 'when finds institution by name ignoring the case sensitive' do
      it 'returns institution by attribute' do
        institution = create(:institution, name: 'Ins')
        results_search = Institution.search('ins')
        expect(institution.name).to eq(results_search.first.name)
      end

      it 'returns institution by search term' do
        institution = create(:institution, name: 'ins')
        results_search = Institution.search('INS')
        expect(institution.name).to eq(results_search.first.name)
      end
    end

    context 'when returns institutions ordered by name' do
      it 'returns ordered' do
        create_list(:institution, 30)
        institutions_ordered = Institution.order(:name)
        institution = institutions_ordered.first
        results_search = Institution.search.order(:name)
        expect(institution.name). to eq(results_search.first.name)
      end
    end
  end
end
