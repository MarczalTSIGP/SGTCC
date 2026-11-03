class Orientation < ApplicationRecord
  include Searchable
  include OrientationStatus
  include OrientationDocuments
  include OrientationValidation
  include AcademicDocumentsInfo
  include UsersToDocument

  attr_accessor :skip_documents_callbacks

  searchable :status, title: { unaccent: true }, relationships: {
    calendars: { fields: [:year] },
    academic: { fields: [{ name: { unaccent: true }, ra: { unaccent: false } }] },
    institution: { fields: [{ name: { unaccent: true }, trade_name: { unaccent: true } }] },
    advisor: { table_name: 'professors', fields: [{ name: { unaccent: true } }] }
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
  validate :validate_supervisor_ids
  validates :calendars, presence: true

  after_create_commit { Orientations::TcoTcaiService.create(self) }
  after_update :recreate_tco_and_tcai, unless: -> { skip_documents_callbacks }

  scope :tcc_one, lambda { |status, year = nil, semester = nil|
    by_tcc_period(:one, status, year, semester)
  }

  scope :tcc_two, lambda { |status, year = nil, semester = nil|
    by_tcc_period(:two, status, year, semester)
  }

  scope :current_tcc_one, ->(status = nil) { by_current_tcc_period(:one, status) }

  scope :current_tcc_two, ->(status = nil) { by_current_tcc_period(:two, status) }

  # Apoio interno dos quatro scopes de período acima. Precisam ser métodos de classe
  # públicos porque, dentro de um `scope`, `self` é a relation, que só delega métodos
  # públicos — mantê-los privados quebraria o encadeamento (`professor.orientations.tcc_one`).
  def self.by_tcc_period(tcc, status, year, semester)
    condition = { tcc: }
    condition['year'] = year if year.present?
    condition['semester'] = semester if semester.present?

    by_calendars(condition, status)
  end

  # Diferente de `by_tcc_period`, ano e semestre entram sempre na condição, mesmo quando
  # `Calendar` não tem período corrente — comportamento preservado dos scopes originais.
  def self.by_current_tcc_period(tcc, status)
    by_calendars(
      { tcc:, year: Calendar.current_year, semester: Calendar.current_semester },
      status
    )
  end

  def self.by_calendars(calendars_condition, status)
    query = joins(:calendars).where(calendars: calendars_condition)
    status.blank? ? query : query.where(status:)
  end

  scope :with_relationships, lambda {
    preload(:documents)
      .includes(:academic, :calendars, :orientation_calendars, :meetings,
                :professor_supervisors, :orientation_supervisors,
                :external_member_supervisors, advisor: [:scholarity])
  }

  scope :recent, lambda {
                   order('calendars.year DESC, calendars.semester DESC, title')
                 }
  scope :order_by_academic, -> { order('academics.name') }

  scope :to_migrate, lambda {
    subquery =
      joins(:calendars)
      .where('calendars.year > ?', Calendar.current_year)
      .or(joins(:calendars)
        .where(
          'calendars.year = ? AND calendars.semester > ?',
          Calendar.current_year,
          Calendar.current_semester
        ))
      .pluck('orientations.id')

    where.not(id: subquery).where(status: 'APPROVED_TCC_ONE')
  }

  def migrate
    Orientations::MigrationService.call(self).migrated
  end

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
    !canceled?
  end

  def can_be_canceled?(professor)
    professor&.role?(:responsible) && active?
  end

  def can_be_edited?
    Orientations::EditabilityPolicy.new(self).editable?
  end

  def can_be_destroyed?
    Orientations::EditabilityPolicy.new(self).destroyable?
  end

  def current_calendar
    calendars.order(year: :desc, semester: :desc, tcc: :desc).first
  end

  delegate :tcc_one?, :tcc_two?, to: :current_calendar

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
  # Os três identificadores são alcançados dinamicamente por
  # `ExaminationBoard#academic_activity` (`orientation.send(identifier)`), então os nomes
  # públicos precisam continuar existindo como métodos.
  def monograph(options = { final_version: false })
    academic_activity_by(:monograph, options)
  end

  def final_monograph
    monograph(final_version: true)
  end

  def project(options = { final_version: false })
    academic_activity_by(:project, options)
  end

  def final_project
    project(final_version: true)
  end

  def proposal(options = { final_version: false })
    academic_activity_by(:proposal, options)
  end

  def final_proposal
    proposal(final_version: true)
  end

  def orientation_type
    if approved?
      :approved if final_monograph.present?
    elsif approved_tcc_one?
      :tcc_one if final_project.present?
    elsif in_progress?
      :in_tcc_one if final_proposal.present?
    else
      :unknown
    end
  end

  def summary
    {
      approved: final_monograph,
      tcc_one: final_project,
      in_tcc_one: final_proposal
    }.fetch(orientation_type, nil)&.summary.to_s
  end

  def approved_date(identifier = :monograph)
    exam_board = examination_boards.find_by(identifier: identifier, situation: :approved)
    exam_board&.date
  end

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
    with_final_activity('APPROVED', :monograph)
  end

  def self.approved_tcc_one
    with_final_activity('APPROVED_TCC_ONE', :project)
  end

  def self.in_tcc_one
    by_status('IN_PROGRESS')
  end

  private

  def recreate_tco_and_tcai
    Orientations::TcoTcaiService.recreate(self)
  end

  def academic_activity_by(identifier, options)
    Orientations::AcademicActivityFinder.call(
      self, identifier, final_version: options[:final_version]
    )
  end

  # Devolve Array, como antes: os consumidores (site público, API e ranking de
  # professores) dependem desse tipo. O que mudou é que o filtro acontece no banco.
  def self.with_final_activity(status, identifier)
    by_status(status)
      .where(id: Orientations::AcademicActivityFinder.orientation_ids(identifier))
      .to_a
  end
  private_class_method :with_final_activity

  def self.by_status(status)
    where(status:).includes(:academic,
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
