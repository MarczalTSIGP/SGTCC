require 'rails_helper'

describe 'ExaminationBoardFile::create', type: :feature, js: true do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let!(:examination_board) { create(:proposal_examination_board, orientation: orientation) }
  let!(:examination_board_note) { create(:examination_board_note, examination_board: examination_board, professor: professor) }
  let(:resource_name) { ExaminationBoardNote.human_attribute_name('appointment_file') }

  before do
    create(:document_type_adpp)
    login_as(professor, scope: :professor)
    visit professors_examination_board_path(examination_board)
  end

  describe '#created' do
    # context 'when the file is valid' do
    #   it 'create a file' do
        # attributes = attributes_for(:examination_board_note)
        # fill_in 'examination_board_note_note', with: attributes[:note]
        # submit_form('input[id="examination_board_note_button"]')

    #     page.execute_script("$('.custom-file-input').css('opacity', '1')")
    #     attach_file 'examination_board_note_appointment_file', FileSpecHelper.pdf.path
    #     submit_form('input[id="examination_board_file_button"]')
    #     expect(page).to have_current_path professors_examination_board_path(examination_board)
    #     expect(page).to have_flash(:success, text: message('update.m'))
    #   end
    # end

    context 'when the apointment text is valid' do
      it 'create a apointment text' do
        content = 'Teste'

        page.execute_script("document.getElementById('examination_board_note_appointment_text').innerHTML = '#{content}';")
      
        # submit_form('input[id="examination_board_file_button"]')
        # expect(page).to have_current_path professors_examination_board_path(examination_board)
        # expect(page).to have_flash(:success, text: message('create.m'))
        
        text = page.execute_script("var text = document.getElementById('examination_board_note_appointment_text').value; return text;")
        # p text

        expect(text).to eq(content)
      end
    end
  end
end
