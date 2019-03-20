class Academic < ApplicationRecord
  include Searchable
  include Classifiable

  attr_accessor :skip_password_validation

  devise :database_authenticatable,
         :rememberable, :validatable,
         authentication_keys: [:ra]

  enum gender: { male: 'M', female: 'F' }, _prefix: :gender

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

  protected

  def password_required?
    return false if skip_password_validation
    super
  end
end
