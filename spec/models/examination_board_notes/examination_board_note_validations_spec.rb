require 'rails_helper'

RSpec.describe ExaminationBoardNote do
  subject(:examination_board_note) { described_class.new }

  describe 'validates' do
    it {
      expect(examination_board_note).to validate_numericality_of(:note)
        .is_less_than_or_equal_to(100)
        .is_greater_than_or_equal_to(0)
    }

    it { is_expected.to allow_value(nil).for(:note) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:examination_board) }
    it { is_expected.to belong_to(:professor).optional }
    it { is_expected.to belong_to(:external_member).optional }
  end
end
