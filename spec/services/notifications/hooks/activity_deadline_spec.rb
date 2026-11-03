require 'rails_helper'

RSpec.describe Notifications::Hooks::Activity do
  describe '.daily_deadline_notifications' do
    let!(:calendar) { create(:calendar) }
    let!(:orientation) { create(:orientation, calendars: [calendar]) }

    before { clear_enqueued_jobs }

    context 'when an activity is within one of the notified windows' do
      # O hook avisa faltando 7, 3, 1 e 0 dias para o prazo final.
      [7, 3, 1, 0].each do |days_before|
        it "enqueues for the academic and the advisor #{days_before} day(s) before" do
          create(:activity, calendar: calendar, final_date: Date.current + days_before)
          clear_enqueued_jobs

          expect do
            described_class.daily_deadline_notifications
          end.to enqueue_job(Notifications::CreateJob).exactly(2).times
        end
      end
    end

    context 'when the activity is outside the notified windows' do
      it 'does not enqueue anything' do
        create(:activity, calendar: calendar, final_date: Date.current + 5)
        clear_enqueued_jobs

        expect do
          described_class.daily_deadline_notifications
        end.not_to enqueue_job(Notifications::CreateJob)
      end
    end

    it 'sends the expected payload to the academic' do
      activity = create(:activity, calendar: calendar, final_date: Date.current + 3)
      clear_enqueued_jobs
      academic = orientation.academic

      expect do
        described_class.daily_deadline_notifications
      end.to have_enqueued_job(Notifications::CreateJob).with(
        hash_including(
          notification_type: 'academic_deadline_upcoming',
          recipient: academic,
          event_key: "activity:#{activity.id}:deadline:3:final_date:" \
                     "#{activity.final_date}:user:academic:#{academic.id}",
          data: hash_including(activity_title: activity.name, days_left: 3)
        )
      )
    end

    it 'sends the expected notification type to the advisor' do
      create(:activity, calendar: calendar, final_date: Date.current + 1)
      clear_enqueued_jobs

      expect do
        described_class.daily_deadline_notifications
      end.to have_enqueued_job(Notifications::CreateJob).with(
        hash_including(notification_type: 'professor_deadline_upcoming',
                       recipient: orientation.advisor)
      )
    end

    it 'does not enqueue when the calendar has no orientations' do
      other_calendar = create(:calendar, :tcc_two)
      create(:activity, :tcc_two, calendar: other_calendar, final_date: Date.current + 1)
      clear_enqueued_jobs

      expect do
        described_class.daily_deadline_notifications
      end.not_to enqueue_job(Notifications::CreateJob)
    end
  end
end
