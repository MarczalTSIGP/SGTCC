require 'rails_helper'

describe 'ExaminationBoard::index', type: :feature, js: true do
  let(:professor) { create(:professor) }
  let!(:examination_board) { create(:examination_board_tcc_one) }

  before do
    examination_board.professors << professor
    login_as(professor, scope: :professor)
    visit professors_examination_boards_path
  end

  describe '#index' do
    context 'when shows the examination boards of the tcc one calendar' do
      it 'shows the examination boards of the tcc one with options' do
        expect(page).to have_contents([examination_board.orientation.academic_with_calendar,
                                       examination_board.orientation.advisor.name,
                                       examination_board.place,
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
