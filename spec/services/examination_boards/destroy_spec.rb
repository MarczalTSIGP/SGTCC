require 'rails_helper'

RSpec.describe ExaminationBoards::Destroy do
  describe '.call' do
    it 'destroys a board without defense minutes' do
      board = create(:examination_board)

      result = described_class.call(board)

      expect(result).to be_destroyed
      expect(result).not_to be_blocked_by_defense_minutes
      expect(ExaminationBoard.exists?(board.id)).to be(false)
    end

    it 'blocks destroying a board with defense minutes' do
      board = create(:examination_board)
      create(:document_type, identifier: board.minutes_type)
      board.create_defense_minutes

      result = described_class.call(board)

      expect(result).not_to be_destroyed
      expect(result).to be_blocked_by_defense_minutes
      expect(ExaminationBoard.exists?(board.id)).to be(true)
    end

    it 'reports a destroy failure separately from a defense-minutes block' do
      board = create(:examination_board)
      allow(board).to receive(:destroy).and_return(false)

      result = described_class.call(board)

      expect(result).to be_failed
      expect(result).not_to be_destroyed
      expect(result).not_to be_blocked_by_defense_minutes
    end
  end
end
