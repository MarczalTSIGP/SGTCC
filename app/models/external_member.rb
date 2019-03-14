class ExternalMember < ApplicationRecord
  include Searchable

  devise :database_authenticatable,
         :rememberable, :validatable,
         authentication_keys: [:email]

  enum gender: { male: 'M', female: 'F' }, _prefix: :gender

  belongs_to :professor_title
  belongs_to :external_member_type

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

  def self.filter_by_company_responsible
    company_responsible = ExternalMember.human_attribute_name('company_responsible')
    company_responsible_id = ExternalMemberType.find_by(name: company_responsible).id

    ExternalMember.where(external_member_type_id: company_responsible_id).order(:name)
  end
end
