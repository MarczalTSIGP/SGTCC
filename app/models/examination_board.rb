class ExaminationBoard < ApplicationRecord
  include Searchable
  include Tcc

  searchable place: { unaccent: true }, relationships: {
    orientation: { fields: [title: { unaccent: true }] }
  }

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

  scope :tcc_one, -> { where(tcc: Calendar.tccs[:one]) }
  scope :tcc_two, -> { where(tcc: Calendar.tccs[:two]) }

  scope :with_relationships, lambda {
    includes(:orientation, :examination_board_attendees, :professors, :external_members)
  }
end
