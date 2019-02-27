class Academic < ApplicationRecord
  devise :database_authenticatable,
         :rememberable, :validatable,
         authentication_keys: [:login]

  enum gender: { male: 'M', female: 'F' }, _prefix: :gender

  validates :name,   presence: true
  validates :gender, presence: true
  validates :ra,
            presence: true,
            uniqueness: true
  validates :email,
            presence: true,
            format: { with: Devise.email_regexp },
            uniqueness: { case_sensetive: false }

  mount_uploader :profile_image, ProfileImageUploader

  attr_writer :login
  attr_accessor :skip_password_validation

  def self.human_genders
    hash = {}
    genders.each_key { |key| hash[I18n.t("enums.genders.#{key}")] = key }
    hash
  end

  def self.search(search)
    if search
      where('unaccent(name) ILIKE unaccent(?) OR email ILIKE ? OR ra ILIKE ?',
            "%#{search}%", "%#{search}%", "%#{search}%").order('name ASC')
    else
      order(:name)
    end
  end

  def login
    @login || ra
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    conditions_hash = conditions.to_h
    login = conditions.delete(:login)

    if login
      where(conditions_hash)
        .find_by(['lower(ra) = :value', { value: login.downcase }])
    elsif conditions.key?(:ra)
      find_by(conditions_hash)
    end
  end

  protected

  def password_required?
    return false if skip_password_validation
    super
  end
end
