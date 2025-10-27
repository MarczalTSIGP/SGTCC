module Notifications
  class ProcessorService
    def self.process(notification)
      new(notification).process
    end

    def initialize(notification)
      @notification = notification
    end

    def process
      return unless @notification
      return if @notification.sent? || @notification.cancelled? || @notification.failed?

      if Notifications::StopChecker.met?(@notification)
        @notification.update!(status: 'cancelled')
        return
      end

      if @notification.attempts >= @notification.max_attempts
        @notification.update!(status: 'failed', last_attempted_at: Time.current)
        return
      end

      Notifications::DispatchJob.perform_later(@notification.id)

      handle_post_enqueue_status(@notification)

    rescue ActiveRecord::RecordNotFound
      Rails.logger.warn("[ProcessorService] Notification #{@notification&.id} not found.")
    rescue => e
      Rails.logger.error("[ProcessorService] Error processing Notification #{@notification&.id}: #{e.message}\n#{e.backtrace.join("\n")}")
    end

    private

    def handle_post_enqueue_status(notification)
      notification.increment!(:attempts)

      template = NotificationTemplate.find_by(key: notification.notification_type)
      rule = template&.notification_rule
      is_single_send = rule&.retry_interval_hours.nil? || rule&.retry_interval_hours == 0

      if is_single_send || notification.attempts >= notification.max_attempts
        notification.update!(status: 'sent', sent_at: Time.current)
      else
        wait_time = calculate_next_attempt_time(rule)
        notification.update!(status: 'scheduled', scheduled_at: wait_time)
      end
    end

    def calculate_next_attempt_time(rule)
      (rule&.retry_interval_hours || 24).hours.from_now
    end

  end
end