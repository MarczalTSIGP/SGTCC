require 'rails_helper'

# Caracterização da regra "professor de TCC I não altera banca de monografia" (REF-28).
RSpec.describe 'Authorization: TCC I professor examination boards' do
  let(:professor) { create(:professor_tcc_one) }

  before { login_as(professor, scope: :professor) }

  it 'allows editing a TCC I board' do
    board = create(:examination_board, :tcc_one, :proposal)
    get edit_tcc_one_professors_examination_board_path(board)
    expect(response).to have_http_status(:ok)
  end

  context 'with a monograph board' do
    let!(:board) { create(:examination_board, :tcc_two, :monograph) }

    it 'blocks editing' do
      get edit_tcc_one_professors_examination_board_path(board)
      expect(response).to redirect_to(tcc_one_professors_examination_boards_tcc_one_path)
      expect(flash[:error]).to eq(I18n.t('flash.not_authorized'))
    end

    it 'blocks destroying' do
      expect do
        delete tcc_one_professors_examination_board_path(board)
      end.not_to change(ExaminationBoard, :count)
      expect(flash[:error]).to eq(I18n.t('flash.not_authorized'))
    end
  end
end
