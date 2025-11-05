class NotificationRule < NotificationDbBase
  belongs_to :notification_template

  validates :days_before, :hours_before, :hours_after, :retry_interval_hours,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.for_key(key)
    joins(:notification_template).find_by(notification_templates: { key: key })
  end
end
