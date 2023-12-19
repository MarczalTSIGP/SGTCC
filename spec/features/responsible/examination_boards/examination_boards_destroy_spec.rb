require 'rails_helper'

describe 'ExaminationBoard::destroy', :js, type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:examination_board) { create(:examination_board_tcc_one) }
  let(:resource_name) { ExaminationBoard.model_name.human }

  before do
    create(:current_calendar_tcc_one)
    create(:current_calendar_tcc_two)

    login_as(responsible, scope: :professor)
    visit responsible_examination_boards_path
  end

  describe '#destroy' do
    context 'when examination board is destroyed' do
      it 'show success message' do
        click_on_destroy_link(responsible_examination_board_path(examination_board))
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
        visit responsible_examination_boards_path
      end

      it 'show warning message' do
        click_on_destroy_link(responsible_examination_board_path(current_examination_board))
        accept_alert
        expect(page).to have_current_path responsible_examination_board_path(
          current_examination_board
        )
        expect(page).to have_flash(
          :warning, text: I18n.t('flash.examination_board.defense_minutes.errors.destroy')
        )
      end
    end
  end
end
