require 'rails_helper'

RSpec.describe ExaminationBoardNote do
  describe 'validates' do
    it {
      expect(subject).to validate_numericality_of(:note)
        .is_less_than_or_equal_to(100)
        .is_greater_than_or_equal_to(0)
    }

    it { is_expected.to allow_value(nil).for(:note) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:examination_board) }
    it { is_expected.to belong_to(:professor).optional }
    it { is_expected.to belong_to(:external_member).optional }
  end

  describe '#after_save' do
    context 'when proposal' do
      let!(:eb) { create(:proposal_examination_board) }

      it 'is approved' do
        note = 60
        attribute_note_for(eb, note)

        expect(eb.final_note).to eq(note)
        expect(eb.situation).to eq('approved')
        status = Orientation.statuses.key('IN_PROGRESS')
        expect(eb.orientation.status).to eq(status)
      end

      it 'is repproved' do
        note = 50
        attribute_note_for(eb, note)

        expect(eb.final_note).to eq(note)
        expect(eb.situation).to eq('reproved')

        status = Orientation.statuses.key('REPROVED_TCC_ONE')
        expect(eb.orientation.status).to eq(status)
      end
    end

    context 'when project' do
      let!(:eb) { create(:project_examination_board) }

      it 'is approved' do
        note = 60
        attribute_note_for(eb, note)

        expect(eb.final_note).to eq(note)
        expect(eb.situation).to eq('approved')

        status = Orientation.statuses.key('APPROVED_TCC_ONE')
        expect(eb.orientation.status).to eq(status)
      end

      it 'is repproved' do
        note = 50
        attribute_note_for(eb, note)

        expect(eb.final_note).to eq(note)
        expect(eb.situation).to eq('reproved')

        status = Orientation.statuses.key('REPROVED_TCC_ONE')
        expect(eb.orientation.status).to eq(status)
      end
    end

    context 'when monograph' do
      let!(:eb) { create(:monograph_examination_board) }

      it 'is approved' do
        note = 60
        attribute_note_for(eb, note)

        expect(eb.final_note).to eq(note)
        expect(eb.situation).to eq('approved')

        status = Orientation.statuses.key('APPROVED')
        expect(eb.orientation.status).to eq(status)
      end

      it 'is repproved' do
        note = 50
        attribute_note_for(eb, note)

        expect(eb.final_note).to eq(note)
        expect(eb.situation).to eq('reproved')

        status = Orientation.statuses.key('REPROVED')
        expect(eb.orientation.status).to eq(status)
      end
    end
  end

  private

  # Helpers
  def attribute_note_for(examination_board, note)
    create(:examination_board_note, examination_board:,
                                    professor: examination_board.orientation.advisor,
                                    note:)

    attribute_note_for_professors(examination_board, note)
    attribute_note_by_external_members(examination_board, note)

    create(:document_type_adpp)
    create(:document_type_adpj)
    create(:document_type_admg)
    examination_board.create_defense_minutes
  end

  def attribute_note_for_professors(examination_board, note)
    examination_board.professors.each do |evaluator|
      create(:examination_board_note, examination_board:,
                                      professor: evaluator,
                                      note:)
    end
  end

  def attribute_note_by_external_members(examination_board, note)
    examination_board.external_members.each do |evaluator|
      create(:examination_board_note, examination_board:,
                                      external_member: evaluator,
                                      note:)
    end
  end
end
