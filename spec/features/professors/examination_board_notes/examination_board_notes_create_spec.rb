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
      it 'create an note' do
        attributes = attributes_for(:examination_board_note)
        fill_in 'examination_board_note_note', with: attributes[:note]
        submit_form('input[id="examination_board_note_button"]')

        expect(page).to have_current_path professors_examination_board_path(examination_board)
        expect(page).to have_flash(:success, text: message('create.f'))
      end
    end

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
        fill_in 'examination_board_note_note', with: attributes[:note]
        submit_form('input[id="examination_board_note_button"]')

        expect(page).to have_current_path professors_examination_board_path(examination_board)
        expect(page).to have_flash(:warning,
                                   text: I18n.t('flash.examination_board_note.errors.edit'))
      end
    end

    context 'when add a file save and later update with a note and save' do
      it 'create a file' do
        attributes = attributes_for(:examination_board_note)

        page.execute_script("$('.custom-file-input').css('opacity', '1')")
        attach_file 'examination_board_note_appointment_file', FileSpecHelper.pdf.path
        submit_form('input[id="examination_board_file_button"]')
        expect(page).to have_current_path professors_examination_board_path(examination_board)
        expect(page).to have_flash(:success, text:  I18n.t("flash.actions.create.m",
                                   resource_name: ExaminationBoardNote.human_attribute_name('appointment_file')))

        attributes = attributes_for(:examination_board_note)
        fill_in 'examination_board_note_note', with: attributes[:note]
        submit_form('input[id="examination_board_note_button"]')
        expect(page).to have_current_path professors_examination_board_path(examination_board)
        expect(page).to have_flash(:success, text: message('update.f'))
      end
    end
  end
end
