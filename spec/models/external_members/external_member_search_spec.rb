require 'rails_helper'

RSpec.describe ExternalMember do
  subject(:em) { build(:external_member) }

  describe '#search' do
    let(:external_member) { create(:external_member) }

    context 'when finds external member by attributes' do
      it 'returns external member by name' do
        results_search = described_class.search(external_member.name)
        expect(external_member.name).to eq(results_search.first.name)
      end

      it 'returns external member by email' do
        results_search = described_class.search(external_member.email)
        expect(external_member.email).to eq(results_search.first.email)
      end
    end

    context 'when finds external member by name with accents' do
      it 'returns external member' do
        external_member = create(:external_member, name: 'João')
        results_search = described_class.search('Joao')
        expect(external_member.name).to eq(results_search.first.name)
      end
    end

    context 'when finds external member by name on search term with accents' do
      it 'returns external member' do
        external_member = create(:external_member, name: 'Joao')
        results_search = described_class.search('João')
        expect(external_member.name).to eq(results_search.first.name)
      end
    end

    context 'when finds external member by name ignoring the case sensitive' do
      it 'returns external member by attribute' do
        external_member = create(:external_member, name: 'Ana')
        results_search = described_class.search('an')
        expect(external_member.name).to eq(results_search.first.name)
      end

      it 'returns external member by search term' do
        external_member = create(:external_member, name: 'ana')
        results_search = described_class.search('AN')
        expect(external_member.name).to eq(results_search.first.name)
      end
    end

    context 'when returns external members ordered by name' do
      it 'returns ordered' do
        create_list(:external_member, 10)
        external_members_ordered = described_class.order(:name)
        external_member = external_members_ordered.first
        results_search = described_class.search.order(:name)
        expect(external_member.name).to eq(results_search.first.name)
      end
    end
  end
end
