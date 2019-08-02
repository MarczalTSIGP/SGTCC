require 'rails_helper'

RSpec.describe Academic, type: :model do
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
  end

  describe '#human_genders' do
    it 'returns the genders' do
      genders = Academic.genders
      hash = {}
      genders.each_key { |key| hash[I18n.t("enums.genders.#{key}")] = key }

      expect(Academic.human_genders).to eq(hash)
    end
  end

  describe '#current_orientation' do
    it 'returns the current orientation by tcc one' do
      academic = create(:academic)
      calendar = create(:current_calendar_tcc_one)
      create(:orientation, calendar: calendar, academic: academic)
      current_orientation = academic.orientations.includes(:calendar).select do |orientation|
        orientation.calendar.id == Calendar.current_by_tcc_one.id
      end
      expect(academic.current_orientation_tcc_one).to eq(current_orientation)
    end

    it 'returns the current orientation by tcc two' do
      academic = create(:academic)
      calendar = create(:current_calendar_tcc_two)
      create(:orientation, calendar: calendar, academic: academic)
      current_orientation = academic.orientations.includes(:calendar).select do |orientation|
        orientation.calendar.id == Calendar.current_by_tcc_two.id
      end
      expect(academic.current_orientation_tcc_two).to eq(current_orientation)
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
        results_search = Academic.search.order(:name)
        expect(academic.name). to eq(results_search.first.name)
      end
    end
  end

  describe '#signatures_signed' do
    let(:orientation) { create(:orientation) }
    let(:academic) { orientation.academic }

    before do
      orientation.signatures.find_by(user_type: :academic).sign
    end

    it 'returns the signed signatures' do
      signatures = Signature.where(user_id: academic.id, user_type: 'AC', status: true)
      expect(academic.signatures_signed).to match_array(signatures)
    end
  end

  describe '#signatures_pending' do
    let(:orientation) { create(:orientation) }
    let(:academic) { orientation.academic }

    it 'returns the pending signatures' do
      signatures = Signature.where(user_id: academic.id, user_type: 'AC', status: false)
      expect(academic.signatures_pending).to match_array(signatures)
    end
  end

  describe '#tsos' do
    let(:orientation) { create(:orientation) }
    let(:academic) { orientation.academic }

    before do
      create(:document_type_tso)
    end

    it 'returns the tsos' do
      tsos = academic.signatures(DocumentType.tso.first)
      expect(academic.tsos).to match_array(tsos)
    end
  end

  describe '#teps' do
    let(:orientation) { create(:orientation) }
    let(:academic) { orientation.academic }

    before do
      create(:document_type_tso)
    end

    it 'returns the teps' do
      teps = academic.signatures(DocumentType.tep.first)
      expect(academic.teps).to match_array(teps)
    end
  end
end
