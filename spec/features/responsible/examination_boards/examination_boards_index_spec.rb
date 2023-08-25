require 'rails_helper'

describe 'ExaminationBoard::index', type: :feature, js: true do
  let(:responsible) { create(:responsible) }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#index' do
    let!(:examination_boards_tcc_one) { create_list(:examination_board_tcc_one, 5) }
    let!(:examination_boards_tcc_two) { create_list(:examination_board_tcc_two, 5) }

    context 'when shows all the examination boards of the tcc one calendar' do
      before do
        visit responsible_examination_boards_tcc_one_path
      end

      it 'shows all the examination boards of the tcc one with options' do
        examination_boards_tcc_one.each do |examination_board|
          expect(page).to have_link(examination_board.orientation.academic_with_calendar,
                                    href: responsible_examination_board_path(examination_board))
          expect(page).to have_contents([examination_board.orientation.advisor.name_with_scholarity,
                                         examination_board.place,
                                         datetime(examination_board.date)])
        end
      end
    end

    context 'when shows all the examination boards of the tcc two calendar' do
      before do
        visit responsible_examination_boards_tcc_two_path
      end

      it 'shows all the examination boards of the tcc two with options' do
        examination_boards_tcc_two.each do |examination_board|
          expect(page).to have_link(examination_board.orientation.academic_with_calendar,
                                    href: responsible_examination_board_path(examination_board))
          expect(page).to have_contents([examination_board.orientation.advisor.name,
                                         examination_board.place,
                                         datetime(examination_board.date)])
        end
      end
    end
  end
end
