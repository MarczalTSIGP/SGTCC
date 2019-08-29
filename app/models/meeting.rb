class Meeting < ApplicationRecord
  belongs_to :orientation

  validates :content,
            presence: true

  scope :with_relationship, -> { includes(orientation: [:academic, :calendar]) }
  scope :not_viewed, -> { where(viewed: false) }

  scope :recent, lambda {
    joins(orientation: [:academic]).order('academics.name ASC, meetings.date DESC')
  }

  def update_viewed
    update(viewed: true)
  end

  def can_update?
    viewed == false
  end
end
