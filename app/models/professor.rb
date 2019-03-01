class Professor < ApplicationRecord
  attr_accessor :skip_password_validation

  devise :database_authenticatable,
         :rememberable, :validatable,
         authentication_keys: [:username]

  enum gender: { male: 'M', female: 'F' }, _prefix: :gender

  belongs_to :professor_type
  belongs_to :professor_role
  belongs_to :professor_title

  validates :name,
            presence: true

  validates :gender,
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

  mount_uploader :profile_image, ProfileImageUploader

  def self.human_genders
    hash = {}
    genders.each_key { |key| hash[I18n.t("enums.genders.#{key}")] = key }
    hash
  end

  def self.search(search = nil)
    if search
      where('unaccent(name) ILIKE unaccent(?) OR email ILIKE ? OR username ILIKE ?',
            "%#{search}%", "%#{search}%", "%#{search}%").order('name ASC')
    else
      order(:name)
    end
  end

  protected

  def password_required?
    return false if skip_password_validation
    super
  end
end
