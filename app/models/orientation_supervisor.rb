class OrientationSupervisor < ApplicationRecord
  belongs_to :orientation

  belongs_to :professor_supervisor,
             class_name: 'Professor',
             inverse_of: :professor_supervisors,
             optional: true

  belongs_to :external_member_supervisor,
             class_name: 'ExternalMember',
             inverse_of: :external_member_supervisors,
             optional: true

  has_many :examination_boards,
           class_name: 'ExaminationBoard',
           through: :orientation,
           source: :examination_board
end
