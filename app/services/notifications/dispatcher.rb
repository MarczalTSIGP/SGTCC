module Notifications
  class Dispatcher
    def initialize(notification)
      @notification = notification
    end

    def call
      template = NotificationTemplate.find_by(key: @notification.notification_type)
      channel = template&.channel || 'email'

      dispatch_channel(channel)
    rescue StandardError => e
      Rails.logger.error("Failed to dispatch #{@notification.id} via #{channel}: #{e.message}")
      raise e
    end

    private

    def dispatch_channel(channel)
      case channel
      when 'email'
        NotificationMailer.generic_email(@notification.id).deliver_later(queue: :mailers)
      else
        Rails.logger.warn("Unknown channel: #{channel} for notification #{@notification.id}")
      end
    end
  end
end
