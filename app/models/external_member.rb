class ExternalMember < ApplicationRecord
  include Searchable

  attr_accessor :skip_password_validation

  devise :database_authenticatable,
         :rememberable, :validatable,
         authentication_keys: [:email]

  enum gender: { male: 'M', female: 'F' }, _prefix: :gender

  belongs_to :professor_title

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

  mount_uploader :profile_image, ProfileImageUploader

  def self.human_genders
    hash = {}
    genders.each_key { |key| hash[I18n.t("enums.genders.#{key}")] = key }
    hash
  end

  protected

  def password_required?
    return false if skip_password_validation
    super
  end
end
