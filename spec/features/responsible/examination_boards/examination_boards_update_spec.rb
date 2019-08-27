require 'rails_helper'

describe 'ExaminationBoard::update', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let!(:orientation) { create(:current_orientation_tcc_two) }
  let(:resource_name) { ExaminationBoard.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#update' do
    let(:examination_board) { create(:examination_board) }

    before do
      visit edit_responsible_examination_board_path(examination_board)
    end

    context 'when data is valid' do
      it 'updates the examination_board' do
        attributes = attributes_for(:examination_board)
        fill_in 'examination_board_place', with: attributes[:place]
        selectize(orientation.academic_with_calendar, from: 'examination_board_orientation_id')
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_examination_board_path(examination_board)
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(page).to have_contents([attributes[:place],
                                       orientation.academic_with_calendar])
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
