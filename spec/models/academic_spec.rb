require 'rails_helper'

RSpec.describe Academic do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
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

  describe 'associations' do
    it { is_expected.to have_many(:examination_boards).through(:orientations) }
    it { is_expected.to have_many(:orientations).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:academic_activities).dependent(:delete_all) }
  end

  describe '#human_genders' do
    it 'returns the genders' do
      genders = described_class.genders
      hash = {}
      genders.each_key { |key| hash[I18n.t("enums.genders.#{key}")] = key }

      expect(described_class.human_genders).to eq(hash)
    end
  end

  describe '#current_orientation' do
    it 'returns the current orientation when it is tcc one' do
      orientation = create(:current_orientation_tcc_one)
      academic = orientation.academic
      expect(academic.current_orientation.tcc_one?).to be true
      expect(academic.current_orientation).to eq(orientation)
    end

    it 'returns the current orientation when it is tcc two' do
      orientation = create(:previous_orientation_tcc_one)
      academic = orientation.academic
      current_orientation = create(:current_orientation_tcc_two, academic:)

      expect(academic.current_orientation.tcc_two?).to be true
      expect(academic.current_orientation).to eq(current_orientation)
    end
  end

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
        create_list(:academic, 30)
        academics_ordered = described_class.order(:name)
        academic = academics_ordered.first
        results_search = described_class.search.order(:name)
        expect(academic.name).to eq(results_search.first.name)
      end
    end
  end

  describe '#documents_signed' do
    let(:orientation) { create(:orientation) }
    let(:academic) { orientation.academic }

    before do
      orientation.signatures.find_by(user_type: :academic).sign
    end

    it 'returns the signed documents' do
      conditions = { user_id: academic.id, user_type: 'AC', status: true }
      documents = Document.joins(:signatures).where(signatures: conditions)
      expect(academic.documents_signed).to match_array(documents)
    end
  end

  describe '#documents_pending' do
    let(:orientation) { create(:orientation) }
    let(:academic) { orientation.academic }

    it 'returns the pending documents' do
      conditions = { user_id: academic.id, user_type: 'AC', status: false }
      documents = Document.joins(:signatures).where(signatures: conditions)
      expect(academic.documents_pending).to match_array(documents)
    end
  end

  describe '#tsos' do
    let(:orientation) { create(:orientation) }
    let(:academic) { orientation.academic }

    before do
      create(:document_type_tso)
    end

    it 'returns the tsos' do
      tsos = academic.documents([true, false], DocumentType.tso.first)
      expect(academic.tsos).to match_array(tsos)
    end
  end

  describe '#teps' do
    let(:orientation) { create(:orientation) }
    let(:academic) { orientation.academic }

    before do
      create(:document_type_tep)
    end

    it 'returns the teps' do
      teps = academic.documents([true, false], DocumentType.tep.first)
      expect(academic.teps).to match_array(teps)
    end
  end

  describe 'methods to ldap' do
    let!(:academic) { create(:academic) }

    it 'find by ra without a' do
      expect(academic).to eql(described_class.find_through_ra(academic.ra))
    end

    it 'find by ra with a' do
      expect(academic).to eql(described_class.find_through_ra("a#{academic.ra}"))
    end
  end
end
