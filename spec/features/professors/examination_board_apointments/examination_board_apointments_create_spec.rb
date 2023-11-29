require 'rails_helper'

describe 'ExaminationBoardApointments::create', :js do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let!(:examination_board) { create(:proposal_examination_board, orientation: orientation) }
  let(:resource_name) { ExaminationBoardNote.human_attribute_name('appointment_file') }

  before do
    create(:document_type_adpp)
    login_as(professor, scope: :professor)
    visit professors_examination_board_path(examination_board)
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

        expect(page).to have_current_path professors_examination_board_path(examination_board)
        expect(page).to have_flash(:success, text: message('update.m'))
      end
    end

    context 'when the apointment text is valid' do
      it 'create a apointment text' do
        content = 'Teste'

        page.execute_script("document.getElementsByClassName('CodeMirror')[0]
                                                        .CodeMirror.getDoc()
                                                        .replaceRange('#{content}', {line: 0});")
        submit_form('input[id="examination_board_file_button"]')

        expect(page).to have_current_path professors_examination_board_path(examination_board)
        expect(page).to have_flash(:success, text: message('create.m'))
        expect(page).to have_field('examination_board_note_appointment_text', type: 'textarea',
                                                                              text: content,
                                                                              visible: :hidden)
      end
    end

    context 'when the file and the apointment text is valid' do
      it 'create a apointment text' do
        page.execute_script("$('.custom-file-input').css('opacity', '1')")
        attach_file 'examination_board_note_appointment_file', FileSpecHelper.pdf.path

        content = 'Teste2'
        page.execute_script("document.getElementsByClassName('CodeMirror')[0]
                                                        .CodeMirror.getDoc()
                                                        .replaceRange('#{content}', {line: 0});")
        submit_form('input[id="examination_board_file_button"]')

        expect(page).to have_current_path professors_examination_board_path(examination_board)
        expect(page).to have_flash(:success, text: message('create.m'))
        expect(page).to have_field('examination_board_note_appointment_text', type: 'textarea',
                                                                              text: content,
                                                                              visible: :hidden)
      end
    end
  end
end
