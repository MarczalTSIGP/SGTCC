class Academic < ApplicationRecord
  include Classifiable
  include Searchable

  devise :database_authenticatable,
         :rememberable, :validatable,
         authentication_keys: [:ra]

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

  mount_uploader :profile_image, ProfileImageUploader
end
