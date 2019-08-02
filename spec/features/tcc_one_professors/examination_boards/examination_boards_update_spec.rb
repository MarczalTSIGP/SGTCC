require 'rails_helper'

describe 'ExaminationBoard::update', type: :feature, js: true do
  let(:professor) { create(:professor_tcc_one) }
  let!(:orientation) { create(:current_orientation_tcc_one) }
  let(:resource_name) { ExaminationBoard.model_name.human }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#update' do
    let(:examination_board) { create(:examination_board) }

    before do
      visit edit_tcc_one_professors_examination_board_path(examination_board)
    end

    context 'when data is valid' do
      it 'updates the examination_board' do
        attributes = attributes_for(:examination_board)
        fill_in 'examination_board_place', with: attributes[:place]
        selectize(orientation.title, from: 'examination_board_orientation_id')
        submit_form('input[name="commit"]')

        expect(page).to have_current_path tcc_one_professors_examination_board_path(examination_board)
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(page).to have_contents([attributes[:place],
                                       orientation.short_title])
      end
    end

    context 'when the examination_board is not valid' do
      it 'show errors' do
        fill_in 'examination_board_place', with: ''
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.examination_board_place')
      end
    end
  end
end
