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
end
