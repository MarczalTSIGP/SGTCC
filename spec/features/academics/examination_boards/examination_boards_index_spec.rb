require 'rails_helper'

describe 'ExaminationBoard::index', type: :feature, js: true do
  let(:orientation) { create(:orientation) }
  let!(:examination_board) { create(:examination_board_tcc_one, orientation: orientation) }
  let(:academic) { orientation.academic }

  before do
    login_as(academic, scope: :academic)
    visit academics_examination_boards_path
  end

  describe '#index' do
    context 'when shows the examination boards of the tcc one calendar' do
      it 'shows the examination boards of the tcc one with options' do
        tcc = ExaminationBoard.tccs[examination_board.tcc]

        expect(page).to have_contents([examination_board.orientation.short_title,
                                       examination_board.place,
                                       tcc,
                                       datetime(examination_board.date)])

        examination_board.professors.each do |professor|
          expect(page).to have_content(professor.name)
        end

        examination_board.external_members.each do |external_member|
          expect(page).to have_content(external_member.name)
        end
      end
    end
  end
end
