class NotificationMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper

  def generic_email(notification_id)
    prepare_email_data(notification_id)

    subject = build_subject
    body_html = render_body_html

    send_email(subject, body_html)
  end

  private

  def prepare_email_data(notification_id)
    @notification = Notification.find(notification_id)
    template = NotificationTemplate.find_by(key: @notification.notification_type)
    @recipient = @notification.recipient
    @payload = @notification.payload.with_indifferent_access.symbolize_keys
    @template_subject = "[SGTCC] #{template&.subject}"
    @template_body = template&.body.to_s
  end

  def build_subject
    @template_subject % @payload
  end

  def render_body_html
    @template_body % @payload
  end

  def send_email(subject, body_html)
    mail(to: @recipient.email, subject: subject) do |format|
      format.html { render html: body_html }
      format.text { render plain: ActionView::Base.full_sanitizer.sanitize(body_html) }
    end
  end
end
