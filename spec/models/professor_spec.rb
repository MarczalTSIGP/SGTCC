require 'rails_helper'

RSpec.describe Professor, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:lattes) }
    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_presence_of(:working_area) }
    it { is_expected.to validate_presence_of(:password) }

    it { is_expected.to validate_length_of(:email) }
    it { is_expected.to validate_length_of(:password) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }

    context 'when email is valid' do
      it { is_expected.to allow_value('email@addresse.foo').for(:email) }
    end

    context 'when email is not valid' do
      it { is_expected.not_to allow_value('foo').for(:email) }
    end

    context 'when lattes is valid' do
      it { is_expected.to allow_value('http://lattes.com/link').for(:lattes) }
    end

    context 'when lattes is not valid' do
      it { is_expected.not_to allow_value('lattes.com').for(:lattes) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:professor_type) }
    it { is_expected.to belong_to(:scholarity) }
    it { is_expected.to have_many(:assignments).dependent(:destroy) }
  end

  describe '#human_genders' do
    it 'returns the genders' do
      genders = Professor.genders
      hash = {}
      genders.each_key { |key| hash[I18n.t("enums.genders.#{key}")] = key }

      expect(Professor.human_genders).to eq(hash)
    end
  end

  describe '#search' do
    let(:professor) { create(:professor) }
    let(:search_fields) do
      { name: { unaccent: true },
        email: { unaccent: false },
        username: { unaccent: false } }
    end

    context 'when finds professor by attributes' do
      it 'returns professor by name' do
        results_search = Professor.search(professor.name, search_fields)
        expect(professor.name).to eq(results_search.first.name)
      end

      it 'returns professor by email' do
        results_search = Professor.search(professor.email, search_fields)
        expect(professor.email).to eq(results_search.first.email)
      end

      it 'returns professor by username' do
        results_search = Professor.search(professor.username, search_fields)
        expect(professor.username).to eq(results_search.first.username)
      end
    end

    context 'when finds professor by name with accents' do
      it 'returns professor' do
        professor = create(:professor, name: 'João')
        results_search = Professor.search('Joao', search_fields)
        expect(professor.name).to eq(results_search.first.name)
      end
    end

    context 'when finds professor by name on search term with accents' do
      it 'returns professor' do
        professor = create(:professor, name: 'Joao')
        results_search = Professor.search('João', search_fields)
        expect(professor.name).to eq(results_search.first.name)
      end
    end

    context 'when finds professor by name ignoring the case sensitive' do
      it 'returns professor by attribute' do
        professor = create(:professor, name: 'Ana')
        results_search = Professor.search('an', search_fields)
        expect(professor.name).to eq(results_search.first.name)
      end

      it 'returns professor by search term' do
        professor = create(:professor, name: 'ana')
        results_search = Professor.search('AN', search_fields)
        expect(professor.name).to eq(results_search.first.name)
      end
    end

    context 'when returns professors ordered by name' do
      it 'returns ordered' do
        create_list(:professor, 30)
        professors_ordered = Professor.order(:name)
        professor = professors_ordered.first
        results_search = Professor.search
        expect(professor.name). to eq(results_search.first.name)
      end
    end
  end
end
