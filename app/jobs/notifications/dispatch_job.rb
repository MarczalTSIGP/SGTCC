class Notifications::DispatchJob < ApplicationJob
  queue_as :notifications

  def perform(notification_id)
    notification = Notification.find_by(id: notification_id)
    return unless notification

    Notifications::Dispatcher.new(notification).call
  rescue ActiveRecord::RecordNotFound
    Rails.logger.warn("[DispatchJob] Notification #{notification_id} not found at send attempt.")
  rescue StandardError => e
    Rails.logger.error("[DispatchJob] Dispatch error for #{notification_id}: #{e.message}")
    raise e
  end
end
