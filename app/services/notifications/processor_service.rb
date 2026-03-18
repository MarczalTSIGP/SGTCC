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

      return if handle_not_notificate?
      return if handle_max_attempts?

      Notifications::DispatchJob.perform_later(@notification.id)

      handle_post_enqueue_status(@notification)
    rescue ActiveRecord::RecordNotFound
      Rails.logger.warn("[ProcessorService] Notification #{@notification&.id} not found.")
    rescue StandardError => e
      handle_processing_error(e)
    end

    private

    def handle_post_enqueue_status(notification)
      notification.increment_attempts

      template = NotificationTemplate.find_by(key: notification.notification_type)
      rule = template&.notification_rule
      is_single_send = rule&.retry_interval_hours.nil? || rule&.retry_interval_hours&.zero?

      if is_single_send || notification.attempts >= notification.max_attempts
        notification.update!(status: 'sent', sent_at: Time.current)
      else
        wait_time = calculate_next_attempt_time(rule)
        notification.update!(status: 'scheduled', scheduled_at: wait_time)
      end
    end

    def handle_not_notificate?
      return true if @notification.sent? || @notification.cancelled? || @notification.failed?

      if Notifications::StopChecker.met?(@notification)
        @notification.update!(status: 'cancelled')
        return true
      end
      false
    end

    def handle_max_attempts?
      return false unless @notification.attempts >= @notification.max_attempts

      @notification.update!(status: 'failed', last_attempted_at: Time.current)
      true
    end

    def handle_processing_error(errors)
      error_message = "[ProcessorService] Error processing Notification #{@notification&.id}: " \
                      "#{errors.message}\n#{errors.backtrace.join("\n")}"

      Rails.logger.error(error_message)
    end

    def calculate_next_attempt_time(rule)
      (rule&.retry_interval_hours || 24).hours.from_now
    end
  end
end
