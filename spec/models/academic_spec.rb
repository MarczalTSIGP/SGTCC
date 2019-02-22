require 'rails_helper'

RSpec.describe Academic, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_uniqueness_of(:ra) }
    it { is_expected.to validate_presence_of(:ra) }
    it { is_expected.to validate_presence_of(:gender) }

    context 'with email' do
      it { is_expected.to allow_value('email@addresse.foo').for(:email) }
      it { is_expected.not_to allow_value('foo').for(:email) }
    end
  end

  describe 'search' do
    let(:academic) { create(:academic) }

    it 'returns academic by name' do
      academics = Academic.search(academic.name)
      expect(academic.name).to eq(academics.first.name)
    end

    it 'returns academic by email' do
      academics = Academic.search(academic.email)
      expect(academic.email).to eq(academics.first.email)
    end

    context 'with accents' do
      it 'in attribute' do
        academic = create(:academic, name: 'João')
        academics = Academic.search('Joao')
        expect(academic.name).to eq(academics.first.name)
      end

      it 'in search term' do
        academic = create(:academic, name: 'Joao')
        academics = Academic.search('João')
        expect(academic.name).to eq(academics.first.name)
      end
    end

    context 'with ignoring case sensitive' do
      it 'in attribute' do
        academic = create(:academic, name: 'Ana')
        academics = Academic.search('an')
        expect(academic.name).to eq(academics.first.name)
      end

      it 'in search term' do
        academic = create(:academic, name: 'ana')
        academics = Academic.search('AN')
        expect(academic.name).to eq(academics.first.name)
      end
    end
  end
end
