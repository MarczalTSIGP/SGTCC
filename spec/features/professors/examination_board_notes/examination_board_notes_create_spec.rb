require 'rails_helper'

describe 'ExaminationBoardNote::create', type: :feature, js: true do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let!(:examination_board) { create(:proposal_examination_board, orientation: orientation) }
  let(:resource_name) { ExaminationBoardNote.model_name.human }

  before do
    create(:document_type_adpp)
    login_as(professor, scope: :professor)
    visit professors_examination_board_path(examination_board)
  end

  describe '#created' do
    context 'when the note is valid' do
      it 'create a note with a random value on the slider' do
        attributes = attributes_for(:examination_board_note)

        random_note = rand(0..1)

        find('#examination_board_note_note').set(random_note)

        submit_form('input[id="examination_board_note_button"]')

        expect(page).to have_current_path professors_examination_board_path(examination_board)
        expect(page).to have_flash(:success, text: message('create.f'))
      end
    end

    # context 'when the note is not valid' do
    #   it 'show errors' do
    #     submit_form('input[id="examination_board_note_button"]')
    #     expect(page).to have_flash(:danger, text: errors_message)
    #     expect(page).to have_message(blank_error_message, in: 'div.examination_board_note_note')
    #   end
    # end

    context 'when the note cant be updated' do
      before do
        examination_board.create_defense_minutes
        professor_signature = examination_board.defense_minutes
                                               .signatures
                                               .find_by(user_id: professor.id,
                                                        user_type: :advisor)
        professor_signature.sign
      end

      it 'redirect to the examination board page' do
        attributes = attributes_for(:examination_board_note)

        random_note = rand(0..1)

        find('#examination_board_note_note').set(random_note)

        submit_form('input[id="examination_board_note_button"]')

        expect(page).to have_current_path professors_examination_board_path(examination_board)
        expect(page).to have_flash(:warning, text: I18n.t('flash.examination_board_note.errors.edit'))
      end
    end
  end
end
