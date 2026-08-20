require 'rails_helper'

RSpec.describe ExaminationBoard do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:place) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:document_available_until) }
  end

  describe 'associations' do
    subject(:examination_board) { described_class.new }

    it { is_expected.to belong_to(:orientation) }
    it { is_expected.to have_many(:examination_board_attendees).dependent(:delete_all) }
    it { is_expected.to have_many(:examination_board_notes).dependent(:delete_all) }

    it 'is expected to have many professors' do
      expect(examination_board).to have_many(:professors).through(:examination_board_attendees)
                                                         .dependent(:destroy)
    end

    it 'is expected to have many external members' do
      expect(examination_board).to have_many(:external_members)
        .through(:examination_board_attendees).dependent(:destroy)
    end
  end

  describe '#human_tcc_identifiers' do
    it 'returns the identifiers' do
      identifiers = described_class.identifiers
      hash = {}
      identifiers.each_key { |key| hash[I18n.t("enums.tcc.identifiers.#{key}")] = key }

      expect(described_class.human_tcc_identifiers).to eq(hash)
    end
  end

  describe '#human_tcc_one_identifiers' do
    it 'returns the tcc one identifiers' do
      hash = described_class.human_tcc_identifiers.first(2).to_h
      expect(described_class.human_tcc_one_identifiers).to eq(hash)
    end
  end
end
