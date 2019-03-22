class Professor < ApplicationRecord
  include Classifiable
  include Searchable
  include ProfileImage

  devise :database_authenticatable,
         :rememberable, :validatable,
         authentication_keys: [:username]

  belongs_to :professor_type
  belongs_to :scholarity

  has_many :assignments, dependent: :destroy
  has_many :roles, through: :assignments

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
end
