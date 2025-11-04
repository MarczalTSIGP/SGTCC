require 'rails_helper'

describe 'ExaminationBoardApointments::create', :js do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let!(:examination_board) { create(:proposal_examination_board, orientation:) }
  let(:resource_name) { ExaminationBoardNote.human_attribute_name('appointment_file') }

  before do
    create(:document_type_adpp)
    login_as(professor, scope: :professor)
    visit professors_examination_board_path(examination_board)
  end

  describe '#created' do
    context 'when the file is valid' do
      it 'create a file' do
        attach_file 'examination_board_note_appointment_file', FileSpecHelper.pdf.path,
                    make_visible: true
        submit_form('input[id="examination_board_file_button"]')

        expect(page).to have_current_path professors_examination_board_path(examination_board),
                                          wait: 5
        expect(page).to have_flash(:success, text: message('create.m'))
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
