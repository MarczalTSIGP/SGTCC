class Assignment < ApplicationRecord
  belongs_to :professor
  belongs_to :role

  validates :professor, uniqueness: { scope: :role_id }
end
