require 'rails_helper'

describe 'TccOneProfessorsExaminationBoardsController', type: :request do
  context 'when update examimation boards with defense minutes generated' do
    let(:responsible) { create(:professor_tcc_one) }
    let(:resource_name) { ExaminationBoard.model_name.human }
    let(:examination_board) { create(:current_examination_board_tcc_one) }

    before do
      create(:document_type_adpp)
      login_as(responsible, scope: :professor)
    end

    it 'does not update fields, except document_avaible_until' do
      examination_board.create_defense_minutes

      params = {
        examination_board: {
          identifier: :monograph, orientation_id: 274,
          professor_ids: [], external_member_ids: [],
          place: 'Place', date: 1.day.from_now,
          document_available_until: 2.days.from_now
        }
      }

      put tcc_one_professors_examination_board_path(examination_board), params: params

      examination_board.reload

      eb = params[:examination_board]

      expect(examination_board.identifier).not_to eql(eb[:identifier])
      expect(examination_board.orientation_id).not_to eql(eb[:orientation_id])
      expect(examination_board.professor_ids).not_to eql(eb[:professor_ids])
      expect(examination_board.external_member_ids).not_to eql(eb[:external_member_ids])
      expect(examination_board.place).not_to eql(eb[:place])
      expect(examination_board.date).not_to eql(eb[:date])

      avaible_until = eb[:document_available_until].utc.to_i
      expect(examination_board.document_available_until.utc.to_i).to eql(avaible_until)
    end
  end

  context 'when destroy examimation boards' do
    let(:professor) { create(:professor_tcc_one) }
    let(:resource_name) { ExaminationBoard.model_name.human }
    let(:examination_board) { create(:current_examination_board_tcc_one) }

    before do
      create(:document_type_adpp)
      login_as(professor, scope: :professor)
    end

    it 'destroy examimation boards' do
      delete tcc_one_professors_examination_board_path(examination_board)
      expect(flash[:success]).to eq(I18n.t('flash.actions.destroy.f',
                                           resource_name: resource_name))
      expect(response).to redirect_to(tcc_one_professors_examination_boards_path)
    end

    it 'dont destroy examimation boards' do
      examination_board.create_defense_minutes
      delete tcc_one_professors_examination_board_path(examination_board)
      expect(flash[:alert]).to eq(
        I18n.t('flash.examination_board.defense_minutes.errors.destroy')
      )
      expect(response).to redirect_to(
        tcc_one_professors_examination_board_path(examination_board)
      )
    end
  end
end
