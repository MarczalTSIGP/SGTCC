class Institution < ApplicationRecord
  include Searchable

  belongs_to :external_member

  before_save :unmask_cnpj

  validates :name,
            presence: true

  validates :trade_name,
            presence: true

  validates :cnpj,
            cnpj: true,
            presence: true,
            uniqueness: { case_sensitive: false }

  def cnpj_formatted
    CNPJ.new(cnpj).formatted
  end

  def unmask_cnpj
    self.cnpj = CNPJ.new(cnpj).stripped
  end
end
