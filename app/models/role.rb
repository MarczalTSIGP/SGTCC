class Role < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :identifier, presence: true, uniqueness: { case_sensitive: false }

  has_many :assignments, dependent: :destroy
  has_many :professors, through: :assignments
end
