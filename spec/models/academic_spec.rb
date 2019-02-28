require 'rails_helper'

RSpec.describe Academic, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_uniqueness_of(:ra).case_insensitive }
    it { is_expected.to validate_presence_of(:ra) }
    it { is_expected.to validate_presence_of(:gender) }

    context 'when email is valid' do
      it { is_expected.to allow_value('email@addresse.foo').for(:email) }
    end

    context 'when email is not valid' do
      it { is_expected.not_to allow_value('foo').for(:email) }
    end
  end

  describe '#human_genders' do
    it 'returns the genders' do
      genders = Academic.genders
      hash = {}
      genders.each_key { |key| hash[I18n.t("enums.genders.#{key}")] = key }

      expect(Academic.human_genders).to eq(hash)
    end
  end

  describe '#search' do
    let(:academic) { create(:academic) }

    context 'when finds academic by attributes' do
      it 'returns academic by name' do
        results_search = Academic.search(academic.name)
        expect(academic.name).to eq(results_search.first.name)
      end

      it 'returns academic by email' do
        results_search = Academic.search(academic.email)
        expect(academic.email).to eq(results_search.first.email)
      end

      it 'returns academic by ra' do
        results_search = Academic.search(academic.ra)
        expect(academic.ra).to eq(results_search.first.ra)
      end
    end

    context 'when finds academic by name with accents' do
      it 'returns academic' do
        academic = create(:academic, name: 'João')
        results_search = Academic.search('Joao')
        expect(academic.name).to eq(results_search.first.name)
      end
    end

    context 'when finds academic by name on search term with accents' do
      it 'returns academic' do
        academic = create(:academic, name: 'Joao')
        results_search = Academic.search('João')
        expect(academic.name).to eq(results_search.first.name)
      end
    end

    context 'when finds academic by name ignoring the case sensitive' do
      it 'returns academic by attribute' do
        academic = create(:academic, name: 'Ana')
        results_search = Academic.search('an')
        expect(academic.name).to eq(results_search.first.name)
      end

      it 'returns academic by search term' do
        academic = create(:academic, name: 'ana')
        results_search = Academic.search('AN')
        expect(academic.name).to eq(results_search.first.name)
      end
    end

    context 'when returns academics ordered by name' do
      it 'returns ordered' do
        create_list(:academic, 30)
        academics_ordered = Academic.order(:name)
        academic = academics_ordered.first
        results_search = Academic.search
        expect(academic.name). to eq(results_search.first.name)
      end
    end
  end
end
