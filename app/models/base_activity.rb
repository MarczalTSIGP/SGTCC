class BaseActivity < ApplicationRecord
  include Searchable
  include Tcc

  searchable name: { unaccent: true }, joins: {
    base_activity_type: { fields: [name: { unaccent: true }] }
  }

  belongs_to :base_activity_type

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :tcc, presence: true

  def self.by_tcc(type, term)
    search(term).order(:name)
                .includes(:base_activity_type)
                .where(tcc: type)
  end

  def self.by_tcc_one(term)
    by_tcc(tccs[:one], term)
  end

  def self.by_tcc_two(term)
    by_tcc(tccs[:two], term)
  end
end
