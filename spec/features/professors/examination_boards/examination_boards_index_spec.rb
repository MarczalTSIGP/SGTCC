require 'rails_helper'

describe 'ExaminationBoard::index', type: :feature, js: true do
  let(:professor) { create(:professor) }
  let!(:examination_board_tcc_one) { create(:examination_board_tcc_one) }
  let!(:examination_board_tcc_two) { create(:examination_board_tcc_two) }

  before do
    examination_board_tcc_one.professors << professor
    examination_board_tcc_two.professors << professor
    login_as(professor, scope: :professor)
  end

  describe '#index' do
    context 'when shows the examination boards of the tcc one calendar' do
      before do
        visit professors_examination_boards_tcc_one_path
      end

      it 'shows the examination boards of the tcc one with options' do
        expect(page).to have_link(examination_board_tcc_one.orientation.academic_with_calendar,
                                  href: professors_examination_board_path(
                                    examination_board_tcc_one
                                  ))

        examination_board = examination_board_tcc_one
        expect(page).to have_contents([examination_board.orientation.advisor.name_with_scholarity,
                                       examination_board.place,
                                       datetime(examination_board.date)])
      end
    end

    context 'when shows the examination boards of the tcc two calendar' do
      before do
        visit professors_examination_boards_tcc_two_path
      end

      it 'shows the examination boards of the tcc two with options' do
        expect(page).to have_link(examination_board_tcc_two.orientation.academic_with_calendar,
                                  href: professors_examination_board_path(
                                    examination_board_tcc_two
                                  ))

        examination_board = examination_board_tcc_two
        expect(page).to have_contents([examination_board.orientation.advisor.name_with_scholarity,
                                       examination_board.place,
                                       datetime(examination_board.date)])
      end
    end
  end
end
