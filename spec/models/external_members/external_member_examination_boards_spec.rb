require 'rails_helper'

RSpec.describe ExternalMember do
  subject(:em) { build(:external_member) }

  describe '#current_examination_boards' do
    let(:orientation_tcc_one) { create(:current_orientation_tcc_one) }
    let(:orientation_tcc_two) { create(:current_orientation_tcc_two) }
    let(:external_member) { orientation_tcc_one.external_member_supervisors.first }

    let(:examination_board_tcc_two) do
      create(:examination_board_tcc_two, orientation: orientation_tcc_two, date: 1.week.ago.to_date)
    end

    before do
      create(:examination_board_tcc_one, orientation: orientation_tcc_one, date: 1.week.ago.to_date)
      examination_board_tcc_two.external_members << external_member
    end

    it 'returns the current examination_boards' do
      examination_boards = (external_member.examination_boards.current_semester +
        external_member.supervision_examination_boards.current_semester)
      expect(external_member.current_examination_boards).to match_array(examination_boards)
      expect(external_member.current_examination_boards.count).to eq(2)
    end
  end
end
