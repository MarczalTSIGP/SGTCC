class Meeting < ApplicationRecord
  belongs_to :orientation

  validates :content,
            presence: true

  scope :with_relationship, -> { includes(orientation: [:academic, :calendars]) }
  scope :not_viewed, -> { where(viewed: false) }

  scope :recent, lambda {
    joins(orientation: [:academic]).order('academics.name ASC, meetings.date DESC')
  }

  after_commit :trigger_create_notifications, on: :create

  def update_viewed
    update(viewed: true)
  end

  def can_update?
    viewed == false
  end

  private

  def trigger_create_notifications
      Notifications::Hooks.meeting_participation_acknowledgment(self)
  end
end
