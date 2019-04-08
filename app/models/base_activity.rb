class BaseActivity < ApplicationRecord
  include Searchable

  searchable name: { unaccent: true }

  belongs_to :base_activity_type

  enum tcc: { one: 'TCC 1', two: 'TCC 2' }, _prefix: :tcc

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :tcc, presence: true

  def self.human_tccs
    hash = {}
    tccs.each_key { |key| hash[I18n.t("enums.tcc.#{key}")] = key }
    hash
  end
end
