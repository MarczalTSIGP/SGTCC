require 'rails_helper'

describe 'ExaminationBoard::index', type: :feature, js: true do
  let(:academic) { create(:academic) }
  let!(:orientation) { create(:orientation, academic: academic) }
  let!(:examination_board) { create(:examination_board_tcc_one, orientation: orientation) }

  before do
    login_as(academic, scope: :academic)
    visit academics_root_path
  end

  describe '#index' do
    context 'when shows the examination boards' do
      it 'shows the examination boards' do
        expect(page).to have_contents([examination_board.orientation.academic_with_calendar,
                                       examination_board.orientation.advisor.name_with_scholarity,
                                       examination_board.place,
                                       datetime(examination_board.date)])

        examination_board.professors.each do |professor|
          expect(page).to have_content(professor.name_with_scholarity)
        end

        examination_board.external_members.each do |external_member|
          expect(page).to have_content(external_member.name_with_scholarity)
        end
      end
    end
  end
end
