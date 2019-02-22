class Academic < ApplicationRecord
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
end
