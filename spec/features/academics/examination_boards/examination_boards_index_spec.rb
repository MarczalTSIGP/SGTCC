require 'rails_helper'

describe 'ExaminationBoard::index' do
  let(:orientation) { create(:orientation) }
  let!(:examination_board) { create(:examination_board_tcc_one, orientation:) }

  before do
    login_as(orientation.academic, scope: :academic)
    visit academics_examination_boards_path
  end

  describe '#index' do
    context 'when shows the examination boards of the tcc one calendar' do
      it 'shows the examination boards of the tcc one with options' do
        link_text = examination_board.orientation.academic_with_calendar
        expect(page).to have_link(link_text,
                                  href: academics_examination_board_path(examination_board))
        expect(page).to have_contents([examination_board.orientation.advisor.name_with_scholarity,
                                       examination_board.place,
                                       datetime(examination_board.date)])
      end
    end
  end
end
