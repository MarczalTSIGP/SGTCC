require 'rails_helper'

describe 'ExaminationBoard::index', type: :feature do
  let!(:orientation) { create(:orientation) }
  let!(:examination_board) { create(:examination_board_tcc_one, orientation: orientation) }

  before do
    login_as(orientation.academic, scope: :academic)
    visit academics_root_path
  end

  describe '#index' do
    context 'when shows the examination boards' do
      it 'shows the examination boards' do
        expect(page).to have_contents([examination_board.orientation.academic_with_calendar,
                                       examination_board.orientation.advisor.name_with_scholarity,
                                       examination_board.place,
                                       datetime(examination_board.date)])
      end
    end
  end
end
