class Professor < ApplicationRecord
  devise :database_authenticatable,
         :rememberable, :validatable,
         authentication_keys: [:username]

  enum gender: { male: 'M', female: 'F' }, _prefix: :gender

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

  def self.search(search = nil)
    if search
      where('unaccent(name) ILIKE unaccent(?) OR email ILIKE ? OR username ILIKE ?',
            "%#{search}%", "%#{search}%", "%#{search}%").order('name ASC')
    else
      order(:name)
    end
  end
end
