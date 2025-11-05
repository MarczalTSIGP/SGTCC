module Notifications
  class SchedulerService
    def initialize(notification_type:, recipient:, event_key:, scheduled_at: nil, data: nil)
      @notification_type = notification_type
      @recipient = recipient
      @event_key = event_key
      @scheduled_at = scheduled_at
      @data = data || {}
    end

    def schedule!
      return unless load_and_check_template

      rule = @template.notification_rule
      scheduled_at_time = compute_scheduled_at(rule)

      notification = find_or_initialize_notification

      return notification if handle_skip_and_log(notification)

      status = scheduled_at_time <= Time.current ? 'pending' : 'scheduled'
      notification.assign_attributes(data: @data, scheduled_at: scheduled_at_time, status: status)

      notification.save!

      log_schedule_success(notification, scheduled_at_time)

      notification
    end

    private

    def load_and_check_template
      @template = NotificationTemplate.find_by(key: @notification_type)
      @template&.active?
    end

    def find_or_initialize_notification
      Notification.find_or_initialize_by(
        recipient: @recipient,
        notification_type: @notification_type,
        event_key: @event_key
      )
    end

    def handle_skip_and_log(notification)
      if notification.persisted? && notification.status.in?(%w[sent failed cancelled])
        # Correção do LineLength aqui
        Rails.logger.info "[SchedulerService] Notification #{notification.id} already finalized. " \
                          'Skipping.'
        return true
      end
      false
    end

    def log_schedule_success(notification, scheduled_at_time)
      Rails.logger.info "[SchedulerService] Notification #{notification.id} scheduled for " \
                        "#{scheduled_at_time} with status #{notification.status}."
    end

    def compute_scheduled_at(rule)
      return @scheduled_at if @scheduled_at.present?

      base_time = calculate_base_time
      return base_time unless rule

      calculated_time = base_time

      calculated_time -= rule.days_before.days   if rule.days_before.positive?
      calculated_time -= rule.hours_before.hours if rule.hours_before.positive?
      calculated_time += rule.hours_after.hours  if rule.hours_after.positive?

      calculated_time
    end

    def calculate_base_time
      %w[final_date date].each do |key|
        next if @data[key].blank?

        begin
          return Time.zone.parse(@data[key].to_s)
        rescue StandardError
          return Time.current
        end
      end
      Time.current
    end
  end
end
