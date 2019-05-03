class Orientation < ApplicationRecord
  include Searchable

  searchable title: { unaccent: true }

  belongs_to :calendar
  belongs_to :academic
  belongs_to :advisor, class_name: 'Professor'
  belongs_to :institution, optional: true

  has_many :orientation_supervisors,
           dependent: :restrict_with_error

  has_many :professor_supervisors,
           class_name: 'Professor',
           foreign_key: :professor_supervisor_id,
           through: :orientation_supervisors

  has_many :external_member_supervisors,
           class_name: 'ExternalMember',
           foreign_key: :external_member_supervisor_id,
           through: :orientation_supervisors

  validates :title, presence: true
end
