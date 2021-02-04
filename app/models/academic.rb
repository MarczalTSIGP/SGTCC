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
  # has_many :calendars, through: :orientations #TODO: test
  has_many :examination_boards,
           through: :orientations

  has_many :academic_activities, dependent: :delete_all

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

  #def current_orientation_by_calendar(calendar)
  #  orientations.includes(:calendar).select do |orientation|
  #    orientation.calendar&.id == calendar&.id
  #  end
  #end

  # def current_orientation_tcc_one
    # orientations.includes('calendars').find_by(calendars: {
    #   year: Calendar.current_year,
    #   semester:  Calendar.current_semester,
    #   tcc: :one
    # })
    # current_orientation.current_calendar.eql?(Calendar.current_by_tcc_one)
    # current_orientation_by_calendar(Calendar.current_by_tcc_one)
  # end

  # def current_orientation_tcc_two
    # current_orientation_by_calendar(Calendar.current_by_tcc_two)
    # current_orientation.current_calendar.eql?(Calendar.current_by_tcc_one)
    # orientations.includes('calendars').find_by(calendars: {
    #   year: Calendar.current_year,
    #   semester:  Calendar.current_semester,
    #   tcc: :two
    # })
    # orientations.joins(:calendars).find_by(calendars: { year: Calendar.current_year, semester: Calendar.current_semester, tcc: :two })
  # end

  def current_orientation
    #orientation = current_orientation_tcc_one | current_orientation_tcc_two
    # orientations.last
    # orientations.includes(:calendars).find_by(calendars: {
    #   year: Calendar.current_year,
    #   semester:  Calendar.current_semester
    # }).references(:calendars)

    orientations.joins(:calendars).find_by(calendars: { year: Calendar.current_year, semester: Calendar.current_semester })
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

  ## Method to LDAP Authentication
  def self.find_through_ra(academic_register)
    return Academic.find_by(ra: academic_register) unless academic_register.chr.eql?('a')

    Academic.find_by(ra: academic_register[1..-1])
  end
end
