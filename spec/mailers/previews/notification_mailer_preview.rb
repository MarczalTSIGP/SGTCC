# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  PREVIEW_EVENT_KEY = 'preview:professor_deadline_upcoming'.freeze

  def professor_deadline_upcoming
    NotificationMailer.generic_email(professor_deadline_upcoming_notification.id)
  end

  private

  def professor_deadline_upcoming_notification
    notification = Notification.find_or_initialize_by(event_key: PREVIEW_EVENT_KEY)
    notification.assign_attributes(preview_notification_attributes)
    notification.save!
    notification
  end

  def preview_notification_attributes
    {
      notification_type: NotificationTemplate.find_by!(key: 'professor_deadline_upcoming').key,
      recipient: Professor.first,
      data: preview_notification_data,
      status: 'pending',
      scheduled_at: nil,
      sent_at: nil,
      last_attempted_at: nil,
      attempts: 0
    }
  end

  def preview_notification_data
    {
      activity_title: 'Entrega da versao final do TCC',
      final_date: Time.zone.local(2026, 3, 26, 23, 59),
      days_left: 7
    }
  end
end
