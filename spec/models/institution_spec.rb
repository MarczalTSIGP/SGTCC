require 'rails_helper'

RSpec.describe Institution do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:trade_name) }
    it { is_expected.to validate_presence_of(:cnpj) }
    it { is_expected.to validate_uniqueness_of(:cnpj).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:external_member) }
    it { is_expected.to have_many(:orientations).dependent(:restrict_with_error) }
  end

  describe 'formatted cnpj' do
    let(:institution) { create(:institution) }

    it 'returns the cnpj formatted' do
      cnpj = institution.cnpj
      expect(cnpj.formatted).to eq(CNPJ.new(cnpj).formatted)
    end
  end

  describe '#search' do
    let(:institution) { create(:institution) }

    context 'when finds institution by attributes' do
      it 'returns institution by name' do
        results_search = described_class.search(institution.name)
        expect(institution.name).to eq(results_search.first.name)
      end

      it 'returns institution by trade name' do
        results_search = described_class.search(institution.trade_name)
        expect(institution.trade_name).to eq(results_search.first.trade_name)
      end

      it 'returns institution by cnpj' do
        results_search = described_class.search(institution.cnpj)
        expect(institution.cnpj).to eq(results_search.first.cnpj)
      end

      it 'returns institution by external member name' do
        results_search = described_class.search(institution.external_member.name)
        expect(institution.external_member.name).to eq(results_search.first.external_member.name)
      end

      it 'returns institution by external member email' do
        results_search = described_class.search(institution.external_member.email)
        expect(institution.external_member.email).to eq(results_search.first.external_member.email)
      end
    end

    context 'when finds institution by trade name with accents' do
      it 'returns institution' do
        institution = create(:institution, trade_name: 'Instituição')
        results_search = described_class.search('Instituicao')
        expect(institution.trade_name).to eq(results_search.first.trade_name)
      end
    end

    context 'when finds institution by trade name on search term with accents' do
      it 'returns institution' do
        institution = create(:institution, trade_name: 'Instituicao')
        results_search = described_class.search('Instituição')
        expect(institution.trade_name).to eq(results_search.first.trade_name)
      end
    end

    context 'when finds institution by trade name ignoring the case sensitive' do
      it 'returns institution by attribute' do
        institution = create(:institution, trade_name: 'Ins')
        results_search = described_class.search('ins')
        expect(institution.trade_name).to eq(results_search.first.trade_name)
      end

      it 'returns institution by search term' do
        institution = create(:institution, trade_name: 'ins')
        results_search = described_class.search('INS')
        expect(institution.trade_name).to eq(results_search.first.trade_name)
      end
    end

    context 'when returns institutions ordered by name' do
      it 'returns ordered' do
        create_list(:institution, 30)
        institutions_ordered = described_class.order(:trade_name)
        institution = institutions_ordered.first
        results_search = described_class.search.order(:trade_name)
        expect(institution.trade_name).to eq(results_search.first.trade_name)
      end
    end

    context 'when CNPJ' do
      let(:institution) { build(:institution) }

      it 'validation should reject invalid cnpj' do
        invalid_cnpjs = %w[00000000000000 11111111111111 22222222222222]
        invalid_cnpjs.each do |invalid_cnpj|
          institution.cnpj = invalid_cnpj
          expect(institution.valid?).to(be(false, "#{invalid_cnpj.inspect} should be invalid"))
          expect(institution.errors[:cnpj]).not_to be_empty
        end
      end

      it 'validation should accept valid cnpj' do
        valid_cnpjs = %w[90794479000178 56990916000190 66270650000165]

        valid_cnpjs.each do |valid_cnpj|
          institution.cnpj = valid_cnpj
          expect(institution.valid?).to(be(true, "#{valid_cnpj.inspect} should be valid"))
          expect(institution.errors[:cnpj]).to be_empty
        end
      end
    end
  end
end
