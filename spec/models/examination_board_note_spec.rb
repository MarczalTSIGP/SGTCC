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

    context 'when all notes are submitted (triggering notifications)' do
      let!(:eb) { create(:monograph_examination_board) }
      let(:academic) { eb.orientation.academic }
      let(:advisor) { eb.orientation.advisor }

      before do
        clear_enqueued_jobs
        eb.examination_board_notes.destroy_all
        other_professors = eb.professors
        external_members = eb.external_members

        other_professors.each do |prof|
          create(:examination_board_note, examination_board: eb, professor: prof, note: 80,
                                          appointment_file: nil, appointment_text: nil)
        end
        external_members.each do |em|
          create(:examination_board_note, examination_board: eb, external_member: em, note: 80,
                                          appointment_file: nil, appointment_text: nil)
        end
      end

      it 'enqueues a job for the academic when its note with appointment is saved' do
        expect do
          create(:examination_board_note,
                 examination_board: eb,
                 professor: advisor,
                 note: 80,
                 appointment_text: 'Revisar a metodologia.')
        end.to have_enqueued_job(Notifications::CreateJob).with(
          hash_including(
            notification_type: 'academic_examination_board_appointments',
            recipient: academic
          )
        )
      end

      it 'does NOT enqueue a job when the last note (without appointment) is saved' do
        expect(eb.appointments?).to be false

        expect do
          create(:examination_board_note,
                 examination_board: eb,
                 professor: advisor,
                 note: 80,
                 appointment_file: nil, appointment_text: nil)
        end.not_to have_enqueued_job(Notifications::CreateJob)
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
