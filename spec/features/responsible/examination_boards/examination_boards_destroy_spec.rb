require 'rails_helper'

describe 'ExaminationBoard::destroy', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let!(:examination_board) { create(:examination_board_tcc_one) }
  let(:resource_name) { ExaminationBoard.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_examination_boards_path
  end

  describe '#destroy' do
    context 'when examination board is destroyed' do
      it 'show success message' do
        click_on_destroy_link(responsible_examination_board_path(examination_board))
        accept_alert
        expect(page).to have_flash(:success, text: message('destroy.f'))
        expect(page).not_to have_content(examination_board.orientation.short_title)
      end
    end
  end
end
