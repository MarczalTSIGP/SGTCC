require 'rails_helper'

RSpec.describe ExaminationBoards::FormContext do
  describe '.for_new' do
    it 'builds a new TCC one board without disabled fields' do
      context = described_class.for_new(tcc: :one)

      expect(context.examination_board).to be_new_record
      expect(context.examination_board.identifier).to be_nil
      expect(context.disabled_field?).to be(false)
    end

    it 'selects current TCC one orientations and activities' do
      orientation = create(:orientation, :current, :tcc_one)
      create(:orientation, :current, :tcc_two)

      context = described_class.for_new(tcc: :one)

      expect(context.orientations).to contain_exactly(orientation)
      expect(context.activities).to eq(Activity.human_tcc_one_identifiers)
    end

    it 'builds a TCC two form context with the monograph default' do
      orientation = create(:orientation, :current, :tcc_two)
      create(:orientation, :current, :tcc_one)

      context = described_class.for_new(tcc: :two)

      expect(context.examination_board.identifier).to eq('monograph')
      expect(context.orientations).to contain_exactly(orientation)
      expect(context.activities).to eq(Activity.human_tcc_two_identifiers)
    end
  end

  describe '.for_board' do
    it 'uses TCC two options and disables fields for a monograph with defense minutes' do
      board = create(:examination_board, :monograph)
      create(:document_type, identifier: board.minutes_type)
      board.create_defense_minutes

      context = described_class.for_board(board)

      expect(context.orientations).to eq(Orientation.current_tcc_two)
      expect(context.activities).to eq(Activity.human_tcc_two_identifiers)
      expect(context.disabled_field?).to be(true)
    end
  end
end
