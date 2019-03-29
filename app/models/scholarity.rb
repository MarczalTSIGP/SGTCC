class Scholarity < ApplicationRecord
  validates :name, :abbr, presence: true, uniqueness: { case_sensitive: false }

  has_many :professors, dependent: :destroy
  has_many :external_members, dependent: :destroy
end
