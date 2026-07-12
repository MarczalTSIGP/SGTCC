require 'rails_helper'

RSpec.describe Professor do
  subject(:professor) { described_class.new }

  describe '#examination_boards' do
    let(:current_date) { Date.new(2026, 7, 15) }
    let(:calendar) do
      find_or_create_calendar(year: 2026, semester: 2, tcc: Calendar.tccs[:one])
    end
    let!(:professor) { create(:professor) }
    let!(:orientation) { create(:orientation, advisor: professor, calendars: [calendar]) }
    let(:tcc_one_examination_board) do
      create(:examination_board, :tcc_one, date: current_date)
    end

    before do
      create(:examination_board, orientation:, date: current_date)
      tcc_one_examination_board.professors << professor
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
