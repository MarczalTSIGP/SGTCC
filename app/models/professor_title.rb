class ProfessorTitle < ApplicationRecord
  validates :name, :abbr, presence: true, uniqueness: { case_sensitive: false }

  has_many :professors, dependent: :destroy
end
