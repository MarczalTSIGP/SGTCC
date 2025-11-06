class Notifications::CreateJob < ApplicationJob
  queue_as :notifications

  def perform(notification_type:, recipient:, event_key:, data: nil, scheduled_at: nil)
    ::Notifications::SchedulerService.new(
      notification_type: notification_type,
      recipient: recipient,
      event_key: event_key,
      data: data,
      scheduled_at: scheduled_at
    ).schedule!

  rescue ActiveRecord::RecordNotFound
    Rails.logger.warn("[CreationJob] Recipient not found for GID: #{recipient_gid}")
  rescue => e
    Rails.logger.error("[CreationJob] Failed to create notification: #{e.message}")
  end
end
