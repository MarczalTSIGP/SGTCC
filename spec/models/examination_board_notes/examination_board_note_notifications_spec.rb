require 'rails_helper'

RSpec.describe ExaminationBoardNote do
  describe '#after_save' do
    context 'when all notes are submitted (triggering notifications)' do
      let!(:eb) { create(:examination_board, :monograph) }
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
end
