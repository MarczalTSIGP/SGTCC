class Meeting < ApplicationRecord
  belongs_to :orientation

  validates :content,
            presence: true

  scope :with_relationship, -> { includes(orientation: [:academic, :calendar]) }

  def update_viewed
    update(viewed: true)
  end

  def can_update?
    viewed == false
  end
end
