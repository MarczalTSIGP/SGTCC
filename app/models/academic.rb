class Academic < ApplicationRecord
  include Classifiable
  include Searchable
  include ProfileImage
  include SignatureFilter

  searchable :ra, :email, name: { unaccent: true }

  devise :database_authenticatable,
         :rememberable, :validatable,
         authentication_keys: [:ra]

  has_many :orientations, dependent: :restrict_with_error

  validates :name,
            presence: true

  validates :gender,
            presence: true

  validates :ra,
            presence: true,
            uniqueness: true

  validates :email,
            presence: true,
            format: { with: Devise.email_regexp },
            uniqueness: { case_sensetive: false }

  def current_orientation_by_calendar(calendar)
    orientations.includes(:calendar).select do |orientation|
      orientation.calendar&.id == calendar&.id
    end
  end

  def current_orientation_tcc_one
    current_orientation_by_calendar(Calendar.current_by_tcc_one)
  end

  def current_orientation_tcc_two
    current_orientation_by_calendar(Calendar.current_by_tcc_two)
  end

  def signatures
    Signature.where(user_id: id, user_type: Signature.user_types[:academic]).recent
  end
end
