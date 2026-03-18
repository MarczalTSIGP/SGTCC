class NotificationMailer < ApplicationMailer
  def generic_email(notification_id)
    prepare_email_data(notification_id)

    mail(to: @recipient.email, subject: build_subject) do |format|
      format.html
      format.text
    end
  end

  private

  def prepare_email_data(notification_id)
    @notification = Notification.find(notification_id)
    template = NotificationTemplate.find_by(key: @notification.notification_type)
    @recipient = @notification.recipient
    @payload = normalized_payload(@notification.payload.with_indifferent_access.symbolize_keys)
    @template_subject = "[SGTCC] #{template&.subject}"
    @template_body = template&.body.to_s
    @body_html = interpolate_template(@template_body)
    @body_text = html_to_text(@body_html)
  end

  def build_subject
    interpolate_template(@template_subject)
  end

  def interpolate_template(template)
    template % @payload
  end

  def normalized_payload(payload)
    payload.transform_values do |value|
      normalize_payload_value(value)
    end
  end

  def normalize_payload_value(value)
    case value
    when ActiveSupport::TimeWithZone, Time, DateTime
      I18n.l(value, format: :datetime)
    when Date
      I18n.l(value, format: :short)
    when String
      normalize_string_payload_value(value)
    else
      value
    end
  end

  def normalize_string_payload_value(value)
    parsed_time = Time.zone.iso8601(value)
    I18n.l(parsed_time, format: :datetime)
  rescue ArgumentError
    value
  end

  def html_to_text(html)
    with_breaks = html.to_s.gsub(%r{<br\s*/?>}i, "\n").gsub(%r{</p>}i, "\n\n")
    ActionView::Base.full_sanitizer.sanitize(with_breaks).squish
  end
end
