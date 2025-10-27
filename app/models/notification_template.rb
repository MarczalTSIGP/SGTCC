class NotificationTemplate < NotificationDbBase
  has_one :notification_rule, dependent: :destroy
  accepts_nested_attributes_for :notification_rule

  validates :key, presence: true, uniqueness: true
  validates :subject, :body, :channel, presence: true

  def rules
    notification_rule
  end
end