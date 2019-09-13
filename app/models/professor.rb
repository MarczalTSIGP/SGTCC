class Professor < ApplicationRecord
  include Classifiable
  include Searchable
  include ProfileImage
  include DocumentFilter
  include ScholarityName
  include ProfessorOrientationFilter
  include ProfessorOrientationReport

  devise :database_authenticatable,
         :rememberable, :validatable,
         authentication_keys: [:username]

  searchable :username, :email, name: { unaccent: true }, relationships: {
    roles: { fields: [identifier: { unaccent: true }, name: { unaccent: true }] }
  }

  belongs_to :professor_type
  belongs_to :scholarity

  has_many :assignments, dependent: :destroy
  has_many :roles, through: :assignments

  has_many :orientations,
           foreign_key: :advisor_id,
           inverse_of: :advisor,
           dependent: :restrict_with_error

  has_many :professor_supervisors,
           class_name: 'OrientationSupervisor',
           foreign_key: :professor_supervisor_id,
           inverse_of: :professor_supervisor,
           dependent: :restrict_with_error

  has_many :supervisions,
           through: :professor_supervisors,
           source: :orientation

  has_many :meetings, through: :orientations

  has_many :orientation_examination_boards,
           through: :orientations,
           source: :examination_boards

  has_many :examination_board_attendees,
           class_name: 'ExaminationBoardAttendee',
           foreign_key: :professor_id,
           inverse_of: :professor,
           source: :examination_board,
           dependent: :destroy

  has_many :guest_examination_boards,
           through: :examination_board_attendees,
           source: :examination_board

  validates :name,
            presence: true

  validates :gender,
            presence: true

  validates :working_area,
            presence: true

  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false }

  validates :lattes,
            presence: true,
            format: { with: URI::DEFAULT_PARSER.make_regexp }

  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: Devise.email_regexp },
            uniqueness: { case_sensitive: false }

  scope :available_advisor, -> { where(available_advisor: true) }
  scope :unavailable_advisor, -> { where(available_advisor: false) }

  def role?(identifier)
    roles.where(identifier: identifier).any?
  end

  def responsible?
    role?(:responsible)
  end

  def user_types
    types = Signature.user_types
    user_types = [types[:advisor], types[:new_advisor], types[:professor_supervisor]]
    user_types.push(types[:professor_responsible]) if role?(:responsible)
    user_types.push(types[:coordinator]) if role?(:coordinator)
    user_types
  end

  def documents(status = [true, false])
    Document.from(Document.by_user(id, user_types, status), :documents).recent
  end

  def orientations_to_form
    order_by = 'calendars.year DESC, calendars.semester ASC, calendars.tcc ASC, academics.name'
    orientations.includes(:academic, :calendar).order(order_by).map do |orientation|
      [orientation.id, orientation.academic_with_calendar]
    end
  end

  def examination_boards(search = nil)
    all = (guest_examination_boards.current_semester.search(search).with_relationships +
     orientation_examination_boards.current_semester.search(search).with_relationships)
    all.sort_by(&:date).reverse.uniq
  end

  def self.current_responsible
    joins(:roles).find_by('roles.identifier': :responsible)
  end

  def self.current_coordinator
    joins(:roles).find_by('roles.identifier': :coordinator)
  end
end
