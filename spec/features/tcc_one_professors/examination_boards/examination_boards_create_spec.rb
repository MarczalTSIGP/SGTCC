require 'rails_helper'

describe 'ExaminationBoard::create', :js do
  let(:professor) { create(:professor_tcc_one) }
  let!(:orientation) { create(:orientation, :current, :tcc_one) }
  let(:resource_name) { ExaminationBoard.model_name.human }

  before do
    login_as(professor, scope: :professor)
    create(:orientation, :current, :tcc_one)
    create(:orientation, :current, :tcc_two)
  end

  describe '#create' do
    before do
      visit new_tcc_one_professors_examination_board_path
    end

    context 'when examination_board is valid' do
      it 'does not show "Monografia" in the identifier input' do
        expect(page).to have_no_text('Monografia')
      end

      it 'does not show "tcc 2" in the identifier input' do
        expect_orientation_select_without_tcc(2)
      end

      it 'create an examination_board' do
        attributes = attributes_for(:examination_board, :tcc_one)
        slim_select(orientation.academic_with_calendar, from: 'examination_board_orientation_id')
        click_on_label(ExaminationBoard.human_tcc_one_identifiers.first[0],
                       in: 'examination_board_identifier')
        fill_in 'examination_board_place', with: attributes[:place]
        submit_form('input[name="commit"]')

        expect_examination_board_created(
          path: tcc_one_professors_examination_boards_tcc_one_path,
          place: attributes[:place],
          show_orientation: false
        )
      end
    end

    context 'when examination_board is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect_examination_board_required_errors
      end
    end
  end
end
