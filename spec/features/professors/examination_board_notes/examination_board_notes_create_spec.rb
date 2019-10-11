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
        attach_file 'examination_board_note_appointment_file', FileSpecHelper.pdf.path
        submit_form('input[name="commit"]')

        expect(page).to have_current_path professors_examination_board_path(examination_board)
        expect(page).to have_flash(:success, text: message('create.f'))
      end
    end

    context 'when the note is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.examination_board_note_note')
        expect(page).to have_message(blank_error_message,
                                     in: 'div.examination_board_note_appointment_file')
      end
    end
  end
end
