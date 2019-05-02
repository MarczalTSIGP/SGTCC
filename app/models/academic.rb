class Academic < ApplicationRecord
  include Classifiable
  include Searchable
  include ProfileImage

  searchable :ra, :email, name: { unaccent: true }

  devise :database_authenticatable,
         :rememberable, :validatable,
         authentication_keys: [:ra]

  has_one :orientation, dependent: :restrict_with_error

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

  def current_tcc?(type)
    return if orientation.blank?
    orientation.calendar.id == Calendar.current_by_tcc(Calendar.tccs[type]).id
  end

  def current_tcc_one?
    current_tcc?('one')
  end

  def current_tcc_two?
    current_tcc?('two')
  end
end
