require 'rails_helper'

RSpec.describe Activity do
  describe 'callbacks' do
    let!(:calendar) { create(:calendar) }

    let!(:orientation) { create(:orientation, calendars: [calendar]) }

    let(:activity) { create(:activity, calendar: calendar) }

    describe 'when a new activity is created calls after_commit: :create' do
      it 'enqueues Notifications::CreateJob for each recipient' do
        expect do
          activity
        end.to enqueue_job(Notifications::CreateJob).exactly(2).times
      end

      it 'enqueues Notifications::CreateJob with the correct arguments for the academic' do
        academic = orientation.academic

        expect do
          activity
        end.to have_enqueued_job(Notifications::CreateJob).with(
          hash_including(
            notification_type: 'activity_calendar_created',
            recipient: academic,
            event_key: "activity_calendar:#{calendar.id}:created:user:Academic:#{academic.id}"
          )
        )
      end

      it 'does not enqueue jobs if the calendar has no orientations' do
        calendar_sem_orientacoes = create(:calendar)

        expect do
          create(:activity, calendar: calendar_sem_orientacoes)
        end.not_to have_enqueued_job(Notifications::CreateJob)
      end
    end

    describe 'when a activity is updated calls after_commit: :update' do
      let!(:activity) { create(:activity, calendar: calendar) }

      before do
        clear_enqueued_jobs
      end

      it 'enqueues Notifications::CreateJob for each recipient when updating' do
        expect do
          activity.update(name: 'Updated Activity Name')
        end.to enqueue_job(Notifications::CreateJob).exactly(2).times
      end

      it 'enqueues Notifications::CreateJob with the correct arguments for the advisor' do
        advisor = orientation.advisor

        expect do
          activity.update(name: 'Updated Activity Name')
        end.to have_enqueued_job(Notifications::CreateJob).with(
          hash_including(
            notification_type: 'activity_calendar_updated',
            recipient: advisor,
            event_key: "activity_calendar:#{calendar.id}:updated:user:Professor:#{advisor.id}"
          )
        )
      end
    end
  end
end
