class Orientation < ApplicationRecord
  include Searchable

  searchable title: { unaccent: true }

  belongs_to :calendar
  belongs_to :academic
  belongs_to :advisor, class_name: Professor.to_s
  belongs_to :institution, optional: true

  has_many :orientation_supervisors,
           dependent: :restrict_with_error

  validates :title, presence: true
end
