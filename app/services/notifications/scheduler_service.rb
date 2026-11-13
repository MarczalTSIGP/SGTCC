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
      template = active_template
      return if template.nil?

      scheduled_at_time = compute_scheduled_at(template.notification_rule)

      notification = find_or_initialize_notification

      return notification if handle_skip_and_log?(notification)

      notification.assign_attributes(data: data, scheduled_at: scheduled_at_time,
                                     status: status_for(scheduled_at_time))

      notification.save!

      log_schedule_success(notification, scheduled_at_time)

      notification
    end

    private

    attr_reader :notification_type, :recipient, :event_key, :scheduled_at, :data

    def active_template
      template = NotificationTemplate.find_by(key: notification_type)

      template if template&.active?
    end

    def status_for(scheduled_at_time)
      scheduled_at_time <= Time.current ? 'pending' : 'scheduled'
    end

    def find_or_initialize_notification
      Notification.find_or_initialize_by(
        recipient: recipient,
        notification_type: notification_type,
        event_key: event_key
      )
    end

    def handle_skip_and_log?(notification)
      if notification.persisted? && notification.status.in?(%w[sent failed cancelled])
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
      return scheduled_at if scheduled_at.present?

      base_time = calculate_base_time
      return base_time unless rule

      apply_rule_offsets(base_time, rule)
    end

    def apply_rule_offsets(base_time, rule)
      calculated_time = base_time

      calculated_time -= rule.days_before.days   if rule.days_before.positive?
      calculated_time -= rule.hours_before.hours if rule.hours_before.positive?
      calculated_time += rule.hours_after.hours  if rule.hours_after.positive?

      calculated_time
    end

    def calculate_base_time
      %w[final_date date].each do |key|
        value = data[key]
        next if value.blank?

        return parse_base_time(key, value)
      end

      Time.current
    end

    # Mantém o fallback para o horário atual quando a data não pode ser interpretada, mas
    # deixa rastro: antes a falha era engolida e a notificação ia para o horário errado sem
    # nenhum registro.
    def parse_base_time(key, value)
      parsed = Time.zone.parse(value.to_s)

      if parsed.nil?
        Rails.logger.warn "[SchedulerService] #{key}=#{value.inspect} could not be parsed into " \
                          'a time. Returning nil, as before.'
      end

      parsed
    rescue ArgumentError, TypeError => e
      Rails.logger.warn "[SchedulerService] #{key}=#{value.inspect} raised #{e.class}: " \
                        "#{e.message}. Falling back to the current time."
      Time.current
    end
  end
end
