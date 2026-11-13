require 'rails_helper'

RSpec.describe ExaminationBoardPolicy do
  let(:professor) { create(:professor_tcc_one) }

  describe '#change_as_tcc_one_professor?' do
    it 'allows a TCC I board' do
      board = build(:examination_board, :tcc_one, :proposal)
      expect(described_class.new(professor, board).change_as_tcc_one_professor?).to be(true)
    end

    it 'denies a monograph board' do
      board = build(:examination_board, :tcc_two, :monograph)
      expect(described_class.new(professor, board).change_as_tcc_one_professor?).to be(false)
    end
  end
end
