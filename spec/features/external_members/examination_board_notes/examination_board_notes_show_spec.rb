require 'rails_helper'

describe 'ExaminationBoardNote::show', :js do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let!(:examination_board) { create(:proposal_examination_board, orientation: orientation) }
  let(:external_member) { examination_board.external_members.first }
  let(:academic) { orientation.academic }

  before do
    examination_board.evaluators.responses.each do |response|
      params = { professor_id: response.evaluator.id } if response.evaluator.is_a?(Professor)
      params ||= { external_member_id: response.evaluator.id }
      params.merge!(examination_board: examination_board)

      create(:examination_board_note, params)
    end

    # create(:document_type_adpp)

    login_as(external_member, scope: :external_member)
    visit external_members_examination_board_path(examination_board)
  end

  context 'when shows the academic note' do
    it 'shows the academic note' do
      expect(page).to have_contents([academic.name,
                                     examination_board.final_note,
                                     examination_board.situation_translated])
    end
  end
end
