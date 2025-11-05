module Notifications
  module HookHelpers
    def schedule_notification(notification_type:, recipient:, data:, event_key:)
      ::Notifications::SchedulerService.new(
        notification_type: notification_type,
        recipient: recipient,
        data: data,
        event_key: event_key
      ).schedule!
    end

    def event_key(*parts)
      parts.flatten.map(&:to_s).join(':')
    end

    def user_identifier(user)
      "#{user.class.name}:#{user.id}"
    end

    def class_name_lower(user)
      user.class.name.downcase
    end
  end
end
