class Professor < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true,
      length: { maximum: 255 },
      format:     { with: VALID_EMAIL_REGEX },
      uniqueness: { case_sensitive: false }
end
