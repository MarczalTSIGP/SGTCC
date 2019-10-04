require 'rails_helper'

describe 'ExaminationBoard::create', type: :feature, js: true do
  let(:professor) { create(:professor_tcc_one) }
  let!(:orientation) { create(:current_orientation_tcc_one) }
  let(:resource_name) { ExaminationBoard.model_name.human }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_tcc_one_professors_examination_board_path
    end

    context 'when examination_board is valid' do
      it 'create an examination_board' do
        attributes = attributes_for(:examination_board)
        selectize(orientation.academic_with_calendar, from: 'examination_board_orientation_id')
        click_on_label(ExaminationBoard.human_tcc_one_identifiers.first[0],
                       in: 'examination_board_identifier')
        fill_in 'examination_board_place', with: attributes[:place]
        submit_form('input[name="commit"]')

        expect(page).to have_current_path tcc_one_professors_examination_boards_tcc_one_path
        expect(page).to have_flash(:success, text: message('create.f'))
        expect(page).to have_message(attributes[:place], in: 'table tbody')
      end
    end

    context 'when examination_board is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.examination_board_place')
        expect(page).to have_message(required_error_message,
                                     in: 'div.examination_board_orientation')
      end
    end
  end
end
