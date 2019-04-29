class Orientation < ApplicationRecord
  belongs_to :calendar
  belongs_to :academic
  belongs_to :advisor, class_name: Professor.to_s
  belongs_to :institution

  validates :title, presence: true
end
