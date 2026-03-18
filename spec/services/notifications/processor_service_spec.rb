require 'rails_helper'

RSpec.describe Notifications::ProcessorService, type: :service do
  include ActiveJob::TestHelper
  include ActiveSupport::Testing::TimeHelpers

  let(:template_single) { create(:notification_template, key: 'single_send') }
  let(:stop_checker_spy) { class_spy(Notifications::StopChecker).as_stubbed_const }
  let(:template_repeatable) { create(:notification_template, key: 'repeatable') }

  # Create rules in a before block (not memoized helpers) so they exist when needed
  before do
    create(:notification_rule, notification_template: template_single, retry_interval_hours: 0,
                               max_retries: 1)
    create(:notification_rule, notification_template: template_repeatable, retry_interval_hours: 2,
                               max_retries: 5)
    allow(stop_checker_spy).to receive(:met?).and_return(false)
    freeze_time
    clear_enqueued_jobs
  end

  context 'when StopConditions are met' do
    before do
      allow(Notifications::CreateJob).to receive(:perform_later)
    end

    it 'does nothing if the notification is nil' do
      expect do
        described_class.process(nil)
      end.not_to have_enqueued_job(Notifications::DispatchJob)
    end

    it 'marks as "cancelled" and stops if the StopCondition is met' do
      notification = create(:notification, status: 'pending')
      allow(stop_checker_spy).to receive(:met?).with(notification).and_return(true)

      expect do
        described_class.process(notification)
      end.not_to have_enqueued_job(Notifications::DispatchJob)

      expect(notification.reload.status).to eq('cancelled')
    end

    it 'marks as "failed" and stops if the maximum attempts are reached' do
      notification = create(:notification, status: 'pending', attempts: 5, max_attempts: 5)

      expect do
        described_class.process(notification)
      end.not_to have_enqueued_job(Notifications::DispatchJob)

      expect(notification.reload.status).to eq('failed')
    end

    it 'does not stop (and enqueues the job) if attempts are less than max' do
      notification = create(:notification, status: 'pending', attempts: 0,
                                           notification_type: 'single_send')

      expect(notification.max_attempts).to eq(1)

      allow(Notifications::DispatchJob).to receive(:perform_later).and_call_original

      expect do
        described_class.process(notification)
      end.to have_enqueued_job(Notifications::DispatchJob)

      expect(notification.reload.status).to eq('sent')
    end
  end

  context 'when processing notifications' do
    it 'creates a new Notifications::DispatchJob and mark as sent' do
      notification = create(:notification, notification_type: 'single_send', status: 'pending',
                                           attempts: 0)

      expect do
        described_class.process(notification)
      end.to have_enqueued_job(Notifications::DispatchJob).with(notification.id)

      notification.reload
      # combine attribute checks to reduce the number of expectations
      expect(notification).to have_attributes(attempts: 1, status: 'sent')
      expect(notification.sent_at).to be_within(1.second).of(Time.current)
    end

    it 'enqueues a new Notifications::DispatchJob, increments attempts and marks as scheduled' do
      notification = create(:notification, notification_type: 'repeatable', status: 'pending',
                                           attempts: 0)

      expect do
        described_class.process(notification)
      end.to have_enqueued_job(Notifications::DispatchJob).with(notification.id)

      notification.reload
      expect(notification).to have_attributes(attempts: 1, status: 'scheduled')
      expect(notification.scheduled_at).to be_within(1.second).of(2.hours.from_now)
    end

    it 'enqueues a new Notifications::DispatchJob, increments attempts and marks as sent' do
      notification = create(:notification, notification_type: 'repeatable', status: 'pending',
                                           attempts: 4, max_attempts: 5)

      expect do
        described_class.process(notification)
      end.to have_enqueued_job(Notifications::DispatchJob).with(notification.id)

      notification.reload
      expect(notification).to have_attributes(attempts: 5, status: 'sent')
      expect(notification.sent_at).to be_within(1.second).of(Time.current)
    end
  end

  context 'when DispatchJob.perform_later fails' do
    let(:notification) { create(:notification, status: 'pending', attempts: 0, max_attempts: 3) }

    it 'logs the error if the DispatchJob.perform_later fails' do
      allow(Notifications::DispatchJob).to receive(:perform_later)
        .and_raise(StandardError, 'Erro de Enfileiramento')

      allow(Rails.logger).to receive(:error)

      # Execute processing (will not raise because ProcessorService rescues)
      described_class.process(notification)

      notification.reload
      expect(notification).to have_attributes(status: 'pending', attempts: 0)
      expect(Rails.logger).to have_received(:error)
        .with(a_string_including('Erro de Enfileiramento'))
    end

    it 'logs the error if the handle_post_enqueue_status fails (e.g. update failure)' do
      notification = create(:notification, status: 'pending', attempts: 0, max_attempts: 3)

      allow(notification).to receive(:increment_attempts).and_raise(StandardError, 'Erro de Update')

      allow(Rails.logger).to receive(:error)

      expect do
        described_class.process(notification)
      end.to have_enqueued_job(Notifications::DispatchJob).with(notification.id)

      notification.reload
      expect(notification).to have_attributes(status: 'pending', attempts: 0)
      expect(Rails.logger).to have_received(:error).with(a_string_including('Erro de Update'))
    end
  end
end
