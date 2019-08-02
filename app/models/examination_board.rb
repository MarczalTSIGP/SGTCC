class ExaminationBoard < ApplicationRecord
  belongs_to :orientation

  validates :place, presence: true
  validates :date, presence: true

  has_many :examination_board_attendees, dependent: :delete_all

  has_many :professors, class_name: 'Professor',
                        foreign_key: :professor_id,
                        through: :examination_board_attendees,
                        dependent: :destroy

  has_many :external_members, class_name: 'ExternalMember',
                              foreign_key: :external_member_id,
                              through: :examination_board_attendees,
                              dependent: :destroy

  scope :with_relationships, lambda {
    includes(:orientation, :professors, :external_members)
  }
end
