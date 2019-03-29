class Institution < ApplicationRecord
  include Searchable
  include CNPJFormatter

  searchable :cnpj,
             trade_name: { unaccent: true },
             name: { unaccent: true }

  belongs_to :external_member

  validates :name,
            presence: true

  validates :trade_name,
            presence: true

  validates :cnpj,
            cnpj: true,
            presence: true,
            uniqueness: { case_sensitive: false }
end
