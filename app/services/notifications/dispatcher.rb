module Notifications
  class Dispatcher
    def initialize(notification)
      @notification = notification
    end

    def call
      template = NotificationTemplate.find_by(key: @notification.notification_type)
      channel = template&.channel || 'email'

      case channel
      when 'email'
        NotificationMailer.generic_email(@notification.id).deliver_later(queue: :mailers)

      else
        Rails.logger.warn("Unknown notification channel: #{channel} for notification #{@notification.id}")
      end
    rescue => e
      Rails.logger.error("Failed to dispatch notification #{@notification.id} via #{channel}: #{e.message}")
      raise e
    end
  end
end