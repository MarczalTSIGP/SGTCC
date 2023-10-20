require 'rails_helper'

describe 'ResponsibleExaminationBoardsController', type: :request do
  context 'when update examimation boards' do
    let(:responsible) { create(:responsible) }
    let(:resource_name) { ExaminationBoard.model_name.human }
    let(:examination_board) { create(:current_examination_board_tcc_one) }

    before do
      create(:document_type_adpp)
      login_as(responsible, scope: :professor)
    end

    it 'dont should update place' do
      examination_board.create_defense_minutes
      old_place = examination_board.place
      new_place = { examination_board: { place: 'New local' } }
      put responsible_examination_board_path(examination_board), params: new_place
      examination_board.reload
      expect(examination_board.place).to eql(old_place)
    end
  end
end
