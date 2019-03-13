class Institution < ApplicationRecord
  include Searchable

  belongs_to :external_member

  validates :name,
            presence: true

  validates :trade_name,
            presence: true

  validates :cnpj,
            presence: true
end
