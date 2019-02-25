class Professor < ApplicationRecord
  devise :database_authenticatable,
         :rememberable, :validatable

  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: Devise.email_regexp },
                    uniqueness: { case_sensitive: false }

  validates :name, presence: true
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false }

  mount_uploader :profile_image, ProfessorProfileImageUploader
end
