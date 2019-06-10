class Orientation < ApplicationRecord
  include Searchable

  searchable :status, title: { unaccent: true }, relationships: {
    calendar: { fields: [:year] },
    academic: { fields: [name: { unaccent: true }, ra: { unaccent: false }] },
    institution: { fields: [name: { unaccent: true }, trade_name: { unaccent: true }] },
    advisor: { table_name: 'professors', fields: [name: { unaccent: true }] }
  }

  belongs_to :calendar
  belongs_to :academic
  belongs_to :advisor, class_name: 'Professor', inverse_of: :orientations
  belongs_to :institution, optional: true

  has_many :orientation_supervisors,
           dependent: :delete_all

  has_many :professor_supervisors,
           class_name: 'Professor',
           foreign_key: :professor_supervisor_id,
           through: :orientation_supervisors,
           dependent: :destroy

  has_many :external_member_supervisors,
           class_name: 'ExternalMember',
           foreign_key: :external_member_supervisor_id,
           through: :orientation_supervisors,
           dependent: :destroy

  validates :title, presence: true
  validate :validates_supervisor_ids

  enum status: {
    "#{I18n.t('enums.orientation.status.RENEWED')}": 'RENEWED',
    "#{I18n.t('enums.orientation.status.APPROVED')}": 'APPROVED',
    "#{I18n.t('enums.orientation.status.CANCELED')}": 'CANCELED',
    "#{I18n.t('enums.orientation.status.IN_PROGRESS')}": 'IN_PROGRESS'
  }, _prefix: :status

  scope :tcc_one, -> { joins(:calendar).where(calendars: { tcc: Calendar.tccs[:one] }) }
  scope :tcc_two, -> { joins(:calendar).where(calendars: { tcc: Calendar.tccs[:two] }) }

  scope :current_tcc_one, lambda {
    joins(:calendar).where(calendars: { tcc: Calendar.tccs[:one],
                                        year: Calendar.current_year,
                                        semester: Calendar.current_semester })
  }

  scope :current_tcc_two, lambda {
    joins(:calendar).where(calendars: { tcc: Calendar.tccs[:two],
                                        year: Calendar.current_year,
                                        semester: Calendar.current_semester })
  }

  scope :with_relationships, lambda {
    includes(:advisor, :academic, :calendar,
             :professor_supervisors, :orientation_supervisors, :external_member_supervisors)
  }

  scope :recent, -> { order('calendars.year DESC, calendars.semester ASC, title, academics.name') }

  def short_title
    title.length > 35 ? "#{title[0..35]}..." : title
  end

  def validates_supervisor_ids
    advisor_is_supervisor = professor_supervisor_ids.include?(advisor_id)
    return true unless advisor_is_supervisor
    message = I18n.t('activerecord.errors.models.orientation.attributes.supervisors.advisor',
                     advisor: advisor.name)
    errors.add(:professor_supervisors, message)
    false
  end

  def supervisors
    professor_supervisors + external_member_supervisors
  end

  def renew(justification)
    next_calendar = Calendar.next_semester(calendar)
    return false if next_calendar.blank?
    self.renewal_justification = justification
    self.status = 'RENEWED'
    save
    new_orientation = dup
    new_orientation.calendar = next_calendar
    new_orientation.save
    new_orientation
  end

  def cancel(justification)
    self.cancellation_justification = justification
    self.status = 'CANCELED'
    save
  end

  def self.by_tcc(data, page, term)
    data.search(term).page(page).with_relationships
  end

  def self.by_tcc_one(page, term)
    by_tcc(tcc_one, page, term).recent
  end

  def self.by_tcc_two(page, term)
    by_tcc(tcc_two, page, term).recent
  end

  def self.by_current_tcc_one(page, term)
    by_tcc(current_tcc_one, page, term).recent
  end

  def self.by_current_tcc_two(page, term)
    by_tcc(current_tcc_two, page, term).recent
  end

  def self.select_status_data
    statuses.map { |index, field| [field, index.capitalize] }.sort!
  end
end
