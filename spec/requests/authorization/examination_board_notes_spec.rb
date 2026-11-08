require 'rails_helper'

# Caracterização da regra "nota/apontamento só pode mudar antes da ata de defesa"
# (REF-28). Os apontamentos (arquivo/texto) ficam de fora de propósito: continuam aceitos
# depois da ata, e o formulário segue visível nesse caso.
RSpec.describe 'Authorization: examination board notes' do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let(:examination_board) { create(:examination_board, :proposal, orientation:) }
  let(:external_member) { create(:external_member) }

  before do
    create(:document_type_adpp)
    examination_board.external_members << external_member
  end

  def edit_alert
    I18n.t('flash.examination_board_note.errors.edit')
  end

  def note_params(evaluator_key, evaluator, **extra)
    { examination_board_note: { note: 90, evaluator_key => evaluator.id,
                                examination_board_id: examination_board.id, **extra } }
  end

  describe 'professor' do
    before { login_as(professor, scope: :professor) }

    def board_path
      professors_examination_board_path(examination_board)
    end

    it 'creates a note before the defense minutes' do
      expect do
        post professors_examination_board_notes_path(examination_board),
             params: note_params(:professor_id, professor)
      end.to change(ExaminationBoardNote, :count).by(1)
      expect(response).to redirect_to(board_path)
    end

    context 'with defense minutes' do
      let!(:note) do
        create(:examination_board_note, examination_board:, professor:, note: 50)
      end

      before { examination_board.create_defense_minutes }

      it 'blocks creating a note' do
        expect do
          post professors_examination_board_notes_path(examination_board),
               params: note_params(:professor_id, professor)
        end.not_to change(ExaminationBoardNote, :count)
        expect(response).to redirect_to(board_path)
        expect(flash[:alert]).to eq(edit_alert)
      end

      it 'blocks updating a note' do
        patch professors_examination_board_note_path(examination_board, note),
              params: note_params(:professor_id, professor)
        expect(note.reload.note).to eq(50)
        expect(response).to redirect_to(board_path)
        expect(flash[:alert]).to eq(edit_alert)
      end

      it 'still accepts appointments after the defense minutes' do
        patch professors_examination_board_file_path(examination_board, note),
              params: { examination_board_note: { appointment_text: 'depois da ata',
                                                  professor_id: professor.id,
                                                  examination_board_id: examination_board.id } }
        expect(note.reload.appointment_text).to eq('depois da ata')
        expect(response).to redirect_to(board_path)
      end
    end
  end

  describe 'external member' do
    before { login_as(external_member, scope: :external_member) }

    def board_path
      external_members_examination_board_path(examination_board)
    end

    context 'with defense minutes' do
      let!(:note) do
        create(:examination_board_note, examination_board:, professor: nil,
                                        external_member:, note: 50)
      end

      before { examination_board.create_defense_minutes }

      it 'blocks updating a note' do
        patch external_members_examination_board_note_path(examination_board, note),
              params: note_params(:external_member_id, external_member)
        expect(note.reload.note).to eq(50)
        expect(response).to redirect_to(board_path)
        expect(flash[:alert]).to eq(edit_alert)
      end

      it 'still accepts appointments after the defense minutes' do
        patch external_members_examination_board_file_path(examination_board, note),
              params: { examination_board_note: { appointment_text: 'depois da ata',
                                                  external_member_id: external_member.id,
                                                  examination_board_id: examination_board.id } }
        expect(note.reload.appointment_text).to eq('depois da ata')
        expect(response).to redirect_to(board_path)
      end
    end
  end
end
