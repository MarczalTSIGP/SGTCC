class Institution < ApplicationRecord
  include Searchable
  include CNPJFormatter

  searchable :cnpj,
             trade_name: { unaccent: true }

  belongs_to :external_member
  has_many :orientations, dependent: :restrict_with_error

  validates :name,
            presence: true

  validates :trade_name,
            presence: true

  validates :cnpj,
            cnpj: true,
            presence: true,
            uniqueness: { case_sensitive: false }
end
