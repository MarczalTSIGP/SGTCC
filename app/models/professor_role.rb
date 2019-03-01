class ProfessorRole < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :professors, dependent: :destroy
end
