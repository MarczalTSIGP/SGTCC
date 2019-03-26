class Activity < ApplicationRecord
  belongs_to :activity_type

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
