class Academic < ApplicationRecord
  enum gender: { male: 'M', female: 'F' }, _prefix: :gender

  validates :name,   presence: true
  validates :ra,     presence: true
  validates :gender, presence: true
  validates :email,
            presence: true,
            format: { with: Devise.email_regexp },
            uniqueness: { case_sensetive: false }

  def self.human_genders
    hash = {}
    genders.keys.each { |key| hash[I18n.t("enums.genders.#{key}")] = key }
    hash
  end
end
