class BaseActivity < ApplicationRecord
  include Searchable
  include Tcc

  searchable name: { unaccent: true }

  belongs_to :base_activity_type

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :tcc, presence: true

  def self.by_tcc(type, term)
    BaseActivity.search(term)
                .order(:name)
                .includes(:base_activity_type)
                .where(tcc: type)
  end
end
