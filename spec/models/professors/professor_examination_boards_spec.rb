require 'rails_helper'

RSpec.describe Professor do
  subject(:professor) { described_class.new }

  describe '#examination_boards' do
    let!(:professor) { create(:professor) }
    let!(:orientation) { create(:orientation, advisor: professor) }
    let(:examination_board_tcc_one) { create(:examination_board_tcc_one, date: 1.week.ago.to_date) }

    before do
      create(:examination_board, orientation:, date: 1.week.ago.to_date)
      examination_board_tcc_one.professors << professor
    end

    it 'is equal guest_examination_boards' do
      examination_boards = (professor.guest_examination_boards +
        professor.orientation_examination_boards)
      expect(professor.examination_boards).to match_array(examination_boards)
      expect(professor.examination_boards.count).to eq(2)
    end
  end

  describe '#current_semester_supervision_examination_boards' do
    let(:examination_board) { create(:examination_board) }
    let(:professor) { examination_board.professors.first }

    it 'returns the supervision by current semester' do
      supervisions = professor.supervision_examination_boards.current_semester.with_relationships
      expect(professor.current_semester_supervision_examination_boards).to eq(supervisions)
    end
  end
end
