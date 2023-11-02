class Orientation < ApplicationRecord
  include Searchable
  include OrientationStatus
  include OrientationFilter
  include OrientationJoin
  include OrientationOption
  include OrientationDocuments
  include OrientationTcoTcai
  include OrientationReport
  include OrientationValidation
  include AcademicDocumentsInfo
  include UsersToDocument

  searchable :status, title: { unaccent: true }, relationships: {
    calendars: { fields: [:year] },
    academic: { fields: [name: { unaccent: true }, ra: { unaccent: false }] },
    institution: { fields: [name: { unaccent: true }, trade_name: { unaccent: true }] },
    advisor: { table_name: 'professors', fields: [name: { unaccent: true }] }
  }

  belongs_to :academic
  belongs_to :advisor, class_name: 'Professor', inverse_of: :orientations
  belongs_to :institution, optional: true

  has_many :orientation_calendars, dependent: :destroy
  has_many :calendars, through: :orientation_calendars

  has_many :orientation_supervisors, dependent: :delete_all
  has_many :signatures, dependent: :destroy
  has_many :documents, lambda {
                         select('DISTINCT ON (documents.id) documents.*')
                       }, through: :signatures
  has_many :meetings, dependent: :destroy
  has_many :examination_boards, dependent: :destroy

  has_many :academic_activities, through: :academic, source: :academic_activities
  has_many :activities, through: :academic_activities, source: :activity

  has_many :professor_supervisors, class_name: 'Professor', foreign_key: :professor_supervisor_id,
                                   through: :orientation_supervisors, dependent: :destroy

  has_many :external_member_supervisors, class_name: 'ExternalMember',
                                         foreign_key: :external_member_supervisor_id,
                                         through: :orientation_supervisors,
                                         dependent: :destroy

  validates :title, presence: true
  validate :validates_supervisor_ids
  validates :calendars, presence: true

  scope :tcc_one, lambda { |status, year = nil, semester = nil|
    join_with_status_by_tcc('one', status, year, semester)
  }

  scope :tcc_two, lambda { |status, year = nil, semester = nil|
    join_with_status_by_tcc('two', status, year, semester)
  }

  scope :current_tcc_one, lambda { |status = nil|
    join_with_status(join_current_calendar_tcc_one, status)
  }

  scope :current_tcc_two, lambda { |status = nil|
    join_with_status(join_current_calendar_tcc_two, status)
  }

  scope :with_relationships, lambda {
    includes(:academic, :calendars, :orientation_calendars, :documents, :meetings,
             :professor_supervisors, :orientation_supervisors,
             :external_member_supervisors, advisor: [:scholarity])
  }

  scope :recent, lambda {
                   order('calendars.year DESC, calendars.semester ASC, title, academics.name')
                 }
  scope :order_by_academic, -> { order('academics.name') }

  scope :migration, -> {
    subquery =
      joins(:calendars)
        .where('calendars.year > ?', Calendar.current_year)
        .or(joins(:calendars)
          .where('calendars.year = ? AND calendars.semester > ?',
          Calendar.current_year, Calendar.current_semester))
        .pluck('orientations.id')

    where.not(id: subquery).where(status: 'APPROVED_TCC_ONE')
  }

  def short_title
    title.length > 35 ? "#{title[0..35]}..." : title
  end

  def supervisors
    professor_supervisors + external_member_supervisors
  end

  def cancel(justification)
    update(cancellation_justification: justification, status: 'CANCELED')
  end

  def active?
    !canceled? && !abandoned?
  end

  def current_calendar
    calendars.last
  end

  # TODO: Refactored and Remove
  def calendar_tcc_one?
    current_calendar.tcc == 'one'
  end

  # TODO: Refactore and Remove
  def calendar_tcc_two?
    current_calendar.tcc == 'two'
  end

  def tcc_one?
    current_calendar.tcc.eql?('one')
  end

  def tcc_two?
    current_calendar.tcc.eql?('two')
  end

  def professor_supervisors_to_document
    users_to_document(professor_supervisors)
  end

  def external_member_supervisors_to_document
    users_to_document(external_member_supervisors)
  end

  def academic_with_calendar
    "#{academic.name} (#{academic.ra}) | #{current_calendar.year_with_semester_and_tcc}"
  end

  # Acadmic activities documents
  #-------------------------------
  def monograph(options = { final_version: false })
    conditions = { identifier: :monograph,
                   final_version: options[:final_version] }

    find_academic_activity(conditions)
  end

  def final_monograph
    monograph(final_version: true)
  end

  def project(options = { final_version: false })
    conditions = { identifier: :project,
                   final_version: options[:final_version] }

    find_academic_activity(conditions)
  end

  def final_project
    project(final_version: true)
  end

  def proposal(options = { final_version: false })
    conditions = { identifier: :proposal,
                   final_version: options[:final_version] }

    find_academic_activity(conditions)
  end

  def final_proposal
    proposal(final_version: true)
  end

  private

  def find_academic_activity(conditions = {})
    academic_activities.joins(:activity)
                       .includes(activity: :calendar)
                       .where(activities: {
                                identifier: conditions[:identifier],
                                final_version: conditions[:final_version],
                                calendar_id: [calendars.pluck(:id)]
                              })
                       .order('calendars.year DESC, calendars.semester DESC')
                       .try(:first)
  end
  # END Acadmic activities documents CONTEXT
  #-------------------------------

  public

  # Class methods
  #----------------------------------------
  def self.to_json_table(orientations)
    orientations.to_json(methods: [:short_title, :final_proposal, :final_project, :final_monograph,
                                   :document_title, :document_summary],
                         include: [:academic, { supervisors: { methods: [:name_with_scholarity] } },
                                   { advisor: { methods: [:name_with_scholarity] } }])
  end

  def self.select_status_data
    statuses.map { |index, field| [field, index.capitalize] }.sort!
  end

  def self.approved
    by_status('APPROVED').reject { |o| o.final_monograph.nil? }
  end

  def self.approved_tcc_one
    by_status('APPROVED_TCC_ONE').reject { |o| o.final_project.nil? }
  end

  def self.in_tcc_one
    by_status('IN_PROGRESS')
  end

  def self.by_status(status)
    where(status: status).includes(:academic,
                                   :professor_supervisors,
                                   :orientation_supervisors,
                                   :external_member_supervisors,
                                   :examination_boards,
                                   advisor: [:scholarity],
                                   professor_supervisors: [:scholarity])
                         .order('examination_boards.date DESC')
  end

  private_class_method :by_status
end
