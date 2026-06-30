require 'rails_helper'

RSpec.describe Professor do
  subject(:professor) { described_class.new }

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

    context 'when professor supervisors is not valid' do
      let(:advisor) { build(:professor) }
      let(:orientation) { build(:orientation, advisor:) }

      it 'validation should reject invalid orientation' do
        orientation.professor_supervisors << advisor
        orientation.save
        expect(orientation.errors[:professor_supervisors]).not_to be_empty
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:professor_type) }
    it { is_expected.to belong_to(:scholarity) }
    it { is_expected.to have_many(:roles).through(:assignments) }
    it { is_expected.to have_many(:meetings).through(:orientations) }
    it { is_expected.to have_many(:assignments).dependent(:destroy) }
    it { is_expected.to have_many(:orientations).dependent(:restrict_with_error) }

    it {
      expect(professor)
        .to(have_many(:professor_supervisors).with_foreign_key('professor_supervisor_id'))
    }

    it { is_expected.to have_many(:supervisions).through(:professor_supervisors) }
    it { is_expected.to have_many(:all_documents).through(:supervisions) }
    it { is_expected.to have_many(:examination_board_attendees) }
    it { is_expected.to have_many(:guest_examination_boards).through(:examination_board_attendees) }
    it { is_expected.to have_many(:orientation_examination_boards).through(:orientations) }
    it { is_expected.to have_many(:supervision_examination_boards).through(:supervisions) }
  end

  describe '#human_genders' do
    it 'returns the genders' do
      genders = described_class.genders
      hash = {}
      genders.each_key { |key| hash[I18n.t("enums.genders.#{key}")] = key }

      expect(described_class.human_genders).to eq(hash)
    end
  end

  describe '#name_with_scholarity' do
    let(:professor) { create(:professor) }

    it 'is equal name with scholarity' do
      name_with_scholarity = "#{professor.scholarity.abbr} #{professor.name}"
      expect(professor.name_with_scholarity).to eq(name_with_scholarity)
    end
  end
end
