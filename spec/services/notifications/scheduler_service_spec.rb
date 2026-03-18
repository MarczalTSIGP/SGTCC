require 'rails_helper'

RSpec.describe Notifications::SchedulerService, type: :service do
  include ActiveSupport::Testing::TimeHelpers

  let(:recipient) { create(:academic) }
  let!(:template) { create(:notification_template, key: 'meu_template', active: true) }

  before { freeze_time }

  context 'when the notification does not exists' do
    let(:base_args) do
      {
        notification_type: 'meu_template',
        recipient: recipient,
        event_key: 'key:1'
      }
    end

    it 'creates a new notification with status "pending" (scheduled for now)' do
      expect do
        described_class.new(**base_args).schedule!
      end.to change(Notification, :count).by(1)

      notification = Notification.last
      expect(notification).to have_attributes(status: 'pending', attempts: 0)
      expect(notification.scheduled_at).to be_within(1.second).of(Time.current)
    end

    it 'creates a new notification with status "scheduled" (based on the days_before rule)' do
      create(:notification_rule, notification_template: template,
                                 days_before: 2,
                                 hours_before: 0,
                                 hours_after: 0)
      event_date = 5.days.from_now

      expect do
        described_class.new(**base_args, data: { 'date' => event_date.to_s }).schedule!
      end.to change(Notification, :count).by(1)

      notification = Notification.last
      expect(notification.status).to eq('scheduled')
      expect(notification.scheduled_at).to be_within(1.second).of(3.days.from_now)
    end

    it 'creates a new notification with status "scheduled" (based on the hours_after rule)' do
      create(:notification_rule, notification_template: template,
                                 days_before: 0,
                                 hours_before: 0,
                                 hours_after: 4)
      event_date = 1.day.from_now

      described_class.new(**base_args, data: { 'date' => event_date.to_s }).schedule!

      notification = Notification.last
      expect(notification.status).to eq('scheduled')
      expect(notification.scheduled_at).to be_within(1.second).of(event_date + 4.hours)
    end

    it 'creates a new notification with status "scheduled" (explicit scheduling)' do
      scheduled_time = 1.day.from_now

      described_class.new(
        **base_args,
        scheduled_at: scheduled_time
      ).schedule!

      notification = Notification.last
      expect(notification.status).to eq('scheduled')
      expect(notification.scheduled_at).to be_within(1.second).of(scheduled_time)
    end
  end

  context 'when the notification already exists' do
    let!(:notification) do
      create(:notification,
             notification_type: 'meu_template',
             recipient: recipient,
             event_key: 'key:1',
             status: 'pending',
             attempts: 1,
             data: { 'foo' => 'bar' })
    end

    let(:new_data) { { 'novo_dado' => true } }

    it 'updates a "pending" notification (and keeps the attempts)' do
      expect do
        described_class.new(
          notification_type: 'meu_template',
          recipient: recipient,
          event_key: 'key:1',
          data: new_data
        ).schedule!
      end.not_to change(Notification, :count)

      notification.reload
      expect(notification).to have_attributes(status: 'pending', attempts: 1)
      expect(notification.data['novo_dado']).to be_truthy
    end

    it 'updates a "scheduled" notification and changes status to "pending" if the time is now' do
      notification.update!(status: 'scheduled', scheduled_at: 2.days.from_now)

      described_class.new(
        notification_type: 'meu_template',
        recipient: recipient,
        event_key: 'key:1'
      ).schedule!

      notification.reload
      expect(notification.status).to eq('pending')
      expect(notification.scheduled_at).to be_within(1.second).of(Time.current)
    end
  end

  context 'when the notification template should not create or update a notification' do
    let(:base_args) do
      {
        notification_type: 'meu_template',
        recipient: recipient,
        event_key: 'key:1'
      }
    end

    it 'does nothing (returns nil) if the template does not exist' do
      result = described_class.new(
        **base_args, notification_type: 'bad_key'
      ).schedule!

      expect(result).to be_nil
      expect(Notification.count).to eq(0)
    end

    it 'does nothing (returns nil) if the template is inactive (active: false)' do
      template.update!(active: false)

      result = described_class.new(**base_args).schedule!

      expect(result).to be_nil
      expect(Notification.count).to eq(0)
    end

    it 'does nothing (returns the notification) if it has already been "sent"' do
      notification = create(:notification, **base_args, status: 'sent', updated_at: 2.days.ago)

      result = described_class.new(**base_args).schedule!

      expect(result).to eq(notification)
      expect(notification.reload.updated_at).to be_within(1.second)
        .of(2.days.ago)
    end

    it 'does nothing (returns the notification) if it has already been "failed"' do
      notification = create(:notification, **base_args, status: 'failed', updated_at: 2.days.ago)

      result = described_class.new(**base_args).schedule!

      expect(result).to eq(notification)
      expect(notification.reload.updated_at).to be_within(1.second).of(2.days.ago)
    end

    it 'does nothing (returns the notification) if it has already been "cancelled"' do
      notification = create(:notification, **base_args, status: 'cancelled', updated_at: 2.days.ago)

      result = described_class.new(**base_args).schedule!

      expect(result).to eq(notification)
      expect(notification.reload.updated_at).to be_within(1.second).of(2.days.ago)
    end
  end
end
