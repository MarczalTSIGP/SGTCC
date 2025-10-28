class Notification < NotificationDbBase
  belongs_to :recipient, polymorphic: true

  before_create :set_max_attempts_from_rules

  serialize :data, coder: JSON

  enum :status, { 
    pending: 'pending', 
    scheduled: 'scheduled', 
    sent: 'sent', 
    failed: 'failed', 
    cancelled: 'cancelled' 
  }

  scope :pending_to_send, -> { where(status: %w[pending scheduled]).where('scheduled_at IS NULL OR scheduled_at <= ?', Time.current) }

  def mark_sent!(time: Time.current)
    update!(status: 'sent', sent_at: time)
  end

  def mark_failed!(time: Time.current)
    update!(status: 'failed', last_attempted_at: time)
  end

  def payload
    data || {}
  end

  private

  def set_max_attempts_from_rules
    notification_template = NotificationTemplate.find_by(key: notification_type)
    notification_rule = notification_template&.rules()
    self.max_attempts = notification_rule&.max_retries || 3
  end
end
