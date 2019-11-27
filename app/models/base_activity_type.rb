class BaseActivityType < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :base_activities, dependent: :destroy
end
