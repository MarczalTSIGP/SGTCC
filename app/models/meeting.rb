class Meeting < ApplicationRecord
  belongs_to :orientation

  validates :content,
            presence: true

  scope :with_relationship, -> { includes(orientation: [:academic, :calendar]) }
end
