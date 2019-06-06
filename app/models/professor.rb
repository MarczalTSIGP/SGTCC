class Professor < ApplicationRecord
  include Classifiable
  include Searchable
  include ProfileImage

  devise :database_authenticatable,
         :rememberable, :validatable,
         authentication_keys: [:username]

  searchable :username, :email, name: { unaccent: true }, joins: {
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

  def role?(identifier)
    roles.where(identifier: identifier).any?
  end
end
