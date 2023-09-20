require 'rails_helper'

describe 'ExaminationBoardNote::create', type: :feature, js: true do
  let(:external_member) { create(:external_member) }
  let(:orientation) { create(:orientation) }
  let!(:examination_board) { create(:proposal_examination_board, orientation: orientation) }
  let(:resource_name) { ExaminationBoardNote.model_name.human }

  before do
    create(:document_type_adpp)
    examination_board.external_members << external_member
    login_as(external_member, scope: :external_member)
    visit external_members_examination_board_path(examination_board)
  end

  describe '#created' do
    context 'when the note is valid' do
      it 'create an note' do
        attributes = attributes_for(:examination_board_note)
        fill_in 'examination_board_note_note', with: attributes[:note]
        page.execute_script("$('.custom-file-input').css('opacity', '1')")
        attach_file 'examination_board_note_appointment_file', FileSpecHelper.pdf.path
        submit_form('input[id="examination_board_note_button"]')

        expect(page).to have_current_path external_members_examination_board_path(examination_board)
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
        em_signature = examination_board.defense_minutes
                                        .signatures
                                        .find_by(user_id: external_member.id,
                                                 user_type: :external_member_evaluator)
        em_signature.sign
      end

      it 'redirect to the examination board page' do
        attributes = attributes_for(:examination_board_note)
        fill_in 'examination_board_note_note', with: attributes[:note]
        page.execute_script("$('.custom-file-input').css('opacity', '1')")
        attach_file 'examination_board_note_appointment_file', FileSpecHelper.pdf.path
        submit_form('input[id="examination_board_note_button"]')

        expect(page).to have_current_path external_members_examination_board_path(examination_board)
        expect(page).to have_flash(:warning,
                                   text: I18n.t('flash.examination_board_note.errors.edit'))
      end
    end
  end
end
