class Meeting < ApplicationRecord
  belongs_to :orientation

  validates :title,
            presence: true

  validates :content,
            presence: true
end
