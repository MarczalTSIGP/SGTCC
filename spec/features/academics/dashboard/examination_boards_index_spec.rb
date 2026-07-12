require 'rails_helper'

describe 'ExaminationBoard::index' do
  let!(:orientation) { create(:orientation, :current, :tcc_one) }
  let!(:examination_board) do
    create(:examination_board, :tcc_one, orientation:, date: 1.week.ago.to_date)
  end

  before do
    login_as(orientation.academic, scope: :academic)
    visit academics_root_path
  end

  describe '#index' do
    context 'when shows the examination boards' do
      it 'shows the examination boards' do
        expect(page).to have_link(examination_board.orientation.academic_with_calendar,
                                  href: academics_examination_board_path(examination_board))
        expect(page).to have_contents([examination_board.orientation.advisor.name_with_scholarity,
                                       examination_board.place,
                                       datetime(examination_board.date)])
      end
    end
  end
end
