class NotificationMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper
  def generic_email(notification_id)
    @notification = Notification.find(notification_id)
    template = NotificationTemplate.find_by(key: @notification.notification_type)
    @recipient = @notification.recipient
    @payload = @notification.payload.with_indifferent_access.symbolize_keys

    subject_template = template&.subject || @payload[:subject] || 'Notificação'

    subject = "[SGTCC] #{subject_template % @payload}"

    body_html = template&.body.to_s % @payload

    mail(to: @recipient.email, subject: subject) do |format|
      format.html { render html: body_html.html_safe }
      format.text { render plain: ActionView::Base.full_sanitizer.sanitize(body_html) }
    end
  end
end
