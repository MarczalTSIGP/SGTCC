class ExternalMember < ApplicationRecord
  include Classifiable
  include Searchable
  include ProfileImage
  include DocumentFilter
  include ScholarityName

  devise :database_authenticatable,
         :rememberable, :validatable,
         :recoverable, authentication_keys: [:email]

  searchable :email, name: { unaccent: true }

  belongs_to :scholarity

  has_many :institutions, dependent: :restrict_with_error

  has_many :external_member_supervisors,
           class_name: 'OrientationSupervisor',
           foreign_key: :external_member_supervisor_id,
           inverse_of: :external_member_supervisor,
           dependent: :restrict_with_error

  has_many :supervisions,
           through: :external_member_supervisors,
           source: :orientation

  has_many :supervision_examination_boards,
           through: :supervisions,
           source: :examination_boards

  has_many :examination_board_attendees,
           class_name: 'ExaminationBoardAttendee',
           foreign_key: :external_member_id,
           inverse_of: :external_member,
           source: :examination_board,
           dependent: :destroy

  has_many :examination_boards,
           through: :examination_board_attendees,
           source: :examination_board

  has_many :all_documents,
           through: :supervisions,
           source: :documents

  validates :name,
            presence: true

  validates :gender,
            presence: true

  validates :working_area,
            presence: true

  validates :personal_page,
            allow_blank: true,
            format: { with: URI::DEFAULT_PARSER.make_regexp }

  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: Devise.email_regexp },
            uniqueness: { case_sensitive: false }

  def current_supervision_by_calendar(calendar)
    supervisions.includes(:calendar).select do |supervision|
      supervision.calendar&.id == calendar&.id
    end
  end

  def current_supervision_tcc_one
    current_supervision_by_calendar(Calendar.current_by_tcc_one)
  end

  def current_supervision_tcc_two
    current_supervision_by_calendar(Calendar.current_by_tcc_two)
  end

  def user_types
    types = Signature.user_types
    user_types = [types[:external_member_supervisor], types[:external_member_evaluator]]
    user_types
  end

  def documents(status = [true, false])
    Document.from(Document.by_user(id, user_types, status), :documents).recent
  end

  def current_examination_boards(term = nil)
    all = (examination_boards.current_semester.search(term).with_relationships +
     supervision_examination_boards.current_semester.search(term).with_relationships)
    all.sort_by(&:date).reverse.uniq
  end
end
