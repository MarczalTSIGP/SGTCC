require 'rails_helper'

RSpec.describe ExaminationBoard do
  describe '#confirm!' do
    subject(:run_confirm) { examination_board.confirm! }

    let!(:examination_board) { create(:examination_board) }
    let(:academic) { examination_board.orientation.academic }
    let(:advisor) { examination_board.orientation.advisor }
    let(:evs) do
      (examination_board.professors + examination_board.external_members + [advisor]).uniq
    end
    let(:total_recipients) { evs.count + 1 }

    before do
      clear_enqueued_jobs
    end

    it 'enqueues the correct number of jobs' do
      expect do
        run_confirm
      end.to have_enqueued_job(Notifications::CreateJob).exactly(total_recipients).times
    end

    it 'enqueues notification jobs for the academic and all members' do
      academic = examination_board.orientation.academic
      advisor = examination_board.orientation.advisor
      evs = (examination_board.professors + examination_board.external_members + [advisor]).uniq
      total_recipients = evs.count + 1

      expect do
        examination_board.confirm!
      end.to have_enqueued_job(Notifications::CreateJob).exactly(total_recipients).times

      expect(Notifications::CreateJob).to have_been_enqueued.with(
        hash_including(
          notification_type: 'academic_confirmed_examination_board',
          recipient: academic
        )
      )
    end

    it 'enqueues the correct jobs for all evaluators' do
      run_confirm

      expect(Notifications::CreateJob).to have_been_enqueued.with(
        hash_including(
          notification_type: 'atendee_confirmed_examination_board',
          recipient: advisor
        )
      )

      examination_board.professors.each do |prof|
        evs.each do |_evaluator|
          expect(Notifications::CreateJob).to have_been_enqueued.with(
            hash_including(notification_type: 'atendee_confirmed_examination_board',
                           recipient: prof)
          )
        end
      end

      examination_board.external_members.each do |ext_member|
        expect(Notifications::CreateJob).to have_been_enqueued.with(
          hash_including(notification_type: 'atendee_confirmed_examination_board',
                         recipient: ext_member)
        )
      end
    end
  end
end
