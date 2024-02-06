require 'rails_helper'

describe 'Supervision::ExaminationBoarsIndex' do
  let(:professor) { create(:professor) }

  before do
    login_as(professor, scope: :professor)
  end

  context 'when shows all the supervisions examinations board' do
    let!(:examination_board) { create(:examination_board_tcc_one, orientation:) }

    let(:orientation) { create(:current_orientation_tcc_one) }
    let(:index_url) { professors_supervision_examination_boards_path }

    before do
      orientation.professor_supervisors << professor
      visit index_url
    end

    it 'shows the examination boards of the tcc one with options' do
      expect_path = professors_supervision_examination_board_path(examination_board)
      expect(page).to have_link(examination_board.orientation.academic_with_calendar,
                                href: expect_path)

      expect(page).to have_contents([examination_board.orientation.advisor.name_with_scholarity,
                                     examination_board.place,
                                     datetime(examination_board.date)])
    end
  end
end
