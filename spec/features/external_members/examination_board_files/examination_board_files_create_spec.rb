require 'rails_helper'

describe 'ExaminationBoardFile::create', type: :feature, js: true do
  let(:external_member) { create(:external_member) }
  let(:orientation) { create(:orientation) }
  let!(:examination_board) { create(:proposal_examination_board, orientation: orientation) }
  let(:resource_name) { ExaminationBoardNote.human_attribute_name('appointment_file') }

  before do
    create(:document_type_adpp)
    examination_board.external_members << external_member
    login_as(external_member, scope: :external_member)
    visit external_members_examination_board_path(examination_board)
  end

  describe '#created' do
    context 'when the file is valid' do
      it 'create a file' do
        attributes = attributes_for(:examination_board_note)
        fill_in 'examination_board_note_note', with: attributes[:note]
        submit_form('input[id="examination_board_note_button"]')

        page.execute_script("$('.custom-file-input').css('opacity', '1')")
        attach_file 'examination_board_note_appointment_file', FileSpecHelper.pdf.path
        submit_form('input[id="examination_board_file_button"]')

        expect(page).to have_current_path external_members_examination_board_path(examination_board)
        expect(page).to have_flash(:success, text: message('update.m'))
      end
    end
  end
end
