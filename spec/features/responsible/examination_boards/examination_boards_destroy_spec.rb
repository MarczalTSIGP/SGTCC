require 'rails_helper'

describe 'ExaminationBoard::destroy', type: [:feature, :request], js: true do
  describe 'ResponsibleExaminationBoardsController' do
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

  describe '#destroy' do
    let(:responsible) { create(:responsible) }
    let!(:examination_board) { create(:examination_board_tcc_one) }
    let(:resource_name) { ExaminationBoard.model_name.human }

    before do
      login_as(responsible, scope: :professor)
      visit responsible_examination_boards_path
    end

    context 'when examination board is destroyed' do
      it 'show success message' do
        click_on_destroy_link(responsible_examination_board_path(examination_board))
        accept_alert
        expect(page).to have_flash(:success, text: message('destroy.f'))
        expect(page).not_to have_content(examination_board.orientation.academic_with_calendar)
      end
    end
  end
end
