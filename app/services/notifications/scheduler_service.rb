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
      template = NotificationTemplate.find_by(key: @notification_type)
      return unless template&.active?

      rule = template.notification_rule
      scheduled_at_time = compute_scheduled_at(rule)

      notification = Notification.find_or_initialize_by(
        recipient: @recipient,
        notification_type: @notification_type,
        event_key: @event_key
      )

      if notification.persisted? && notification.status.in?(['sent', 'failed', 'cancelled'])
        Rails.logger.info "[SchedulerService] Notification #{notification.id} already finalized. Skipping."
        return notification # Retorna a notificação existente
      end

      notification.assign_attributes(
        data: @data,
        scheduled_at: scheduled_at_time,
        status: scheduled_at_time <= Time.current ? 'pending' : 'scheduled',
      )

      notification.save!

      Rails.logger.info "[SchedulerService] Notification #{notification.id} scheduled for #{scheduled_at_time} with status #{notification.status}."

      notification
    end

    private

    def compute_scheduled_at(rule)
      return @scheduled_at if @scheduled_at.present?

      base_time = if @data['final_date'].present?
                    Time.zone.parse(@data['final_date'].to_s) rescue Time.current
                  elsif @data['date'].present?
                    Time.zone.parse(@data['date'].to_s) rescue Time.current
                  else
                    Time.current
                  end

      if rule
        calculated_time = base_time
        calculated_time -= rule.days_before.days   if rule.days_before.positive?
        calculated_time -= rule.hours_before.hours if rule.hours_before.positive?
        calculated_time += rule.hours_after.hours  if rule.hours_after.positive?
        calculated_time
      else
        base_time
      end
    end
  end
end