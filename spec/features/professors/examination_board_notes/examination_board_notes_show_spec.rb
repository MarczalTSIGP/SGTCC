require 'rails_helper'

describe 'ExaminationBoardNote::show', :js do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let!(:examination_board) { create(:proposal_examination_board, orientation: orientation) }
  let(:resource_name) { ExaminationBoardNote.model_name.human }

  before do
    create(:document_type_adpp)
    login_as(professor, scope: :professor)
  end

  describe '#show' do
    context 'when shows the academic note' do
      let(:academic) { orientation.academic }

      before do
        create(:examination_board_note, examination_board: examination_board,
                                        professor: professor)

        examination_board.professors.each do |evaluator|
          create(:examination_board_note, examination_board: examination_board,
                                          professor: evaluator)
        end

        examination_board.external_members.each do |evaluator|
          create(:examination_board_note, examination_board: examination_board,
                                          external_member: evaluator)
        end

        visit professors_examination_board_path(examination_board)
      end

      it 'shows the academic note' do
        expect(page).to have_contents([academic.name,
                                       examination_board.final_note,
                                       examination_board.situation_translated])
      end
    end
  end
end
