require 'rails_helper'

RSpec.describe ExaminationBoardNote, type: :model do
  describe 'validates' do
    it { is_expected.not_to validate_presence_of(:note) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:examination_board) }
    it { is_expected.to belong_to(:professor) }
    it { is_expected.to belong_to(:external_member) }
  end

  describe '#after_save' do
    let!(:examination_board) { create(:project_examination_board) }
    let(:professor) { examination_board.orientation.advisor }
    let(:note) { 90 }

    before do
      create(:document_type_adpj)
      examination_board.professors.destroy_all
      examination_board.external_members.destroy_all
    end

    context 'when creates the defense minutes and academic is approved' do
      let(:note) { 60 }

      before do
        create(:examination_board_note, examination_board: examination_board,
                                        professor: professor,
                                        note: note)
      end

      it 'update the examination board and create defense minutes' do
        expect(examination_board.final_note).to eq(note)
        expect(examination_board.situation).to eq('approved')
      end

      it 'update the orientation status' do
        status = Orientation.statuses.key('APPROVED_TCC_ONE')
        expect(examination_board.orientation.status).to eq(status)
      end
    end

    context 'when creates the defense minutes and academic is approved and its proposal' do
      let!(:examination_board) { create(:proposal_examination_board) }
      let(:professor) { examination_board.orientation.advisor }
      let(:note) { 60 }

      before do
        create(:document_type_adpp)
        examination_board.professors.destroy_all
        examination_board.external_members.destroy_all
        create(:examination_board_note, examination_board: examination_board,
                                        professor: professor,
                                        note: note)
      end

      it 'update the examination board and create defense minutes' do
        expect(examination_board.final_note).to eq(note)
        expect(examination_board.situation).to eq('approved')
      end

      it 'not update the orientation status' do
        expect(examination_board.orientation.status).to eq(Orientation.statuses.key('IN_PROGRESS'))
      end
    end

    context 'when creates the defense minutes and academic is reproved' do
      let(:note) { 59 }

      before do
        create(:examination_board_note, examination_board: examination_board,
                                        professor: professor,
                                        note: note)
      end

      it 'update the examination board and create defense minutes' do
        expect(examination_board.final_note).to eq(note)
        expect(examination_board.situation).to eq('reproved')
      end
    end
  end
end
