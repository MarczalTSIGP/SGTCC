require 'rails_helper'

describe 'ExaminationBoard::new', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { ExaminationBoard.model_name.human }
  let!(:orientation) { create(:current_orientation_tcc_two) }

  before do
    login_as(responsible, scope: :professor)
    create(:current_orientation_tcc_one)
    create(:current_orientation_tcc_two)
  end

  describe '#new' do
    before do
      visit responsible_examination_boards_new_tcc_two_path
    end

    context 'when examination_board tcc two is valid' do
      it 'does not show "Projeto" and "Proposta" in the identifier input' do
        expect(page).not_to have_content('Projeto')
        expect(page).not_to have_content('Proposta')
      end

      it 'does not show "tcc 1" in the identifier input' do
        find('#examination_board_orientation_id-selectized').click

        all('.selectize-dropdown-content .option').each do |option|
          expect(option.text).not_to match(/TCC: 1/i)
        end
      end

      it 'create an examination_board tcc two' do
        attributes = attributes_for(:examination_board_tcc_two)
        click_on_label('Monografia', in: 'examination_board_identifier')
        selectize(orientation.academic_with_calendar, from: 'examination_board_orientation_id')
        fill_in 'examination_board_place', with: attributes[:place]
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_examination_boards_tcc_two_path
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
