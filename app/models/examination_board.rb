class ExaminationBoard < ApplicationRecord
  belongs_to :orientation

  validates :place, presence: true
  validates :date, presence: true
end
