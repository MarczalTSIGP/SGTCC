require 'rails_helper'

RSpec.describe ExternalMember do
  subject(:em) { build(:external_member) }

  describe '#current_examination_boards' do
    let(:current_date) { Date.new(2026, 7, 15) }
    let(:orientation_tcc_one) do
      calendar = find_or_create_calendar(year: 2026, semester: 2, tcc: Calendar.tccs[:one])
      create(:orientation, calendars: [calendar])
    end
    let(:orientation_tcc_two) do
      calendar = find_or_create_calendar(year: 2026, semester: 2, tcc: Calendar.tccs[:two])
      create(:orientation, calendars: [calendar])
    end
    let(:external_member) { orientation_tcc_one.external_member_supervisors.first }

    let(:tcc_two_examination_board) do
      create(
        :examination_board,
        :tcc_two,
        orientation: orientation_tcc_two,
        date: current_date
      )
    end

    before do
      create(
        :examination_board,
        :tcc_one,
        orientation: orientation_tcc_one,
        date: current_date
      )
      tcc_two_examination_board.external_members << external_member
    end

    it 'returns the current examination_boards' do
      examination_boards = (external_member.examination_boards.current_semester +
        external_member.supervision_examination_boards.current_semester)
      expect(external_member.current_examination_boards).to match_array(examination_boards)
      expect(external_member.current_examination_boards.count).to eq(2)
    end
  end
end
