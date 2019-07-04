class ExternalMember < ApplicationRecord
  include Classifiable
  include Searchable
  include ProfileImage
  include SignatureFilter

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

  def signatures(condition = {})
    Signature.where(condition).where(
      user_id: id, user_type: Signature.user_types[:external_member_supervisor]
    )
  end
end
