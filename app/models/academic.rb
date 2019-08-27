class Academic < ApplicationRecord
  include Classifiable
  include Searchable
  include ProfileImage
  include DocumentFilter

  searchable :ra, :email, name: { unaccent: true }

  devise :database_authenticatable,
         :rememberable, :validatable,
         authentication_keys: [:ra]

  has_many :orientations, dependent: :restrict_with_error

  has_many :meetings, through: :orientations

  has_many :examination_boards,
           through: :orientations

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

  def current_orientation
    orientation = current_orientation_tcc_one | current_orientation_tcc_two
    orientation.first
  end

  def documents(status = [true, false], document_type = nil, query: {})
    user_types = Signature.user_types[:academic]
    query[:documents] = { document_type: document_type } if document_type.present?
    Document.from(Document.by_user(id, user_types, status), :documents).where(query).recent
  end

  def tsos
    documents([true, false], DocumentType.tso.first)
  end

  def teps
    documents([true, false], DocumentType.tep.first)
  end
end
