class ExaminationBoard < ApplicationRecord
  require 'action_view'
  include ActionView::Helpers::DateHelper
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

  scope :current_semester, -> { where('date >= ?', Calendar.start_date) }
  scope :recent, -> { order(date: :desc) }

  scope :with_relationships, lambda {
    includes(external_members: [:scholarity],
             professors: [:scholarity],
             orientation: [:academic, :calendar, advisor: [:scholarity]])
  }

  def status
    current_date = Date.current.to_s
    board_date = Date.parse(date.to_s).to_s
    return 'today' if board_date == current_date
    board_date > current_date ? 'next' : 'occurred'
  end

  def distance_of_date
    i18n = 'views.tables.examination_board'
    board_date = I18n.l(date, format: :datetime)
    return I18n.t("#{i18n}.today", time: I18n.l(date, format: :time)) if status == 'today'
    distance_of_time = distance_of_time_in_words(board_date, Time.current)
    I18n.t("#{i18n}.#{status}", distance: distance_of_time)
  end
end
