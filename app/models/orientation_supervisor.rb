class OrientationSupervisor < ApplicationRecord
  belongs_to :orientation

  belongs_to :professor_supervisor,
             class_name: 'Professor',
             foreign_key: 'professor_supervisor_id',
             inverse_of: :professor_supervisors,
             optional: true

  belongs_to :external_member_supervisor,
             class_name: 'ExternalMember',
             foreign_key: 'external_member_supervisor_id',
             inverse_of: :external_member_supervisors,
             optional: true

  scope :with_orientation, -> { includes(orientation: [:academic, :advisor, :calendar]) }
end
