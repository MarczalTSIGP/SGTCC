require 'rails_helper'

describe 'ExaminationBoard::destroy', type: :feature, js: true do
  let(:professor) { create(:professor_tcc_one) }
  let!(:examination_board) { create(:examination_board_tcc_one) }
  let(:resource_name) { ExaminationBoard.model_name.human }

  before do
    login_as(professor, scope: :professor)
    visit tcc_one_professors_examination_boards_path
  end

  describe '#destroy' do
    context 'when examination board is destroyed' do
      it 'show success message' do
        click_on_destroy_link(tcc_one_professors_examination_board_path(examination_board))
        accept_alert
        expect(page).to have_flash(:success, text: message('destroy.f'))
        expect(page).not_to have_content(examination_board.orientation.academic_with_calendar)
      end
    end

    context 'when the examination board cant be destroyed' do
      let!(:current_examination_board) { create(:current_examination_board_tcc_one) }

      before do
        create(:document_type_adpp)
        current_examination_board.create_defense_minutes.blank?
        visit tcc_one_professors_examination_boards_path
      end

      it 'show warning message' do
        click_on_destroy_link(tcc_one_professors_examination_board_path(current_examination_board))
        accept_alert
        expect(page).to have_current_path tcc_one_professors_examination_board_path(
          current_examination_board
        )
        expect(page).to have_flash(
          :warning, text: I18n.t('flash.examination_board.defense_minutes.errors.destroy')
        )
      end
    end
  end
end
