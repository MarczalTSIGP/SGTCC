require 'rails_helper'

RSpec.describe ExaminationBoardNote do
  describe '#after_save' do
    context 'when proposal' do
      let!(:eb) { create(:examination_board, :proposal) }

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

      # Should use examination_board.orientation.update_column(:status, orientation_status)
      # instead of examination_board.orientation.update(status: orientation_status)
      # If use update, it will trigger after_save and recreate tco and tcai
      it 'does not trigger orientation after_save' do
        tco_id = eb.orientation.tco.id
        tcai_id = eb.orientation.tcai.id

        note = 60
        attribute_note_for(eb, note)

        expect(eb.orientation.tco.id).to eq(tco_id)
        expect(eb.orientation.tcai.id).to eq(tcai_id)
      end
    end

    context 'when project' do
      let!(:eb) { create(:examination_board, :project) }

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
      let!(:eb) { create(:examination_board, :monograph) }

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
