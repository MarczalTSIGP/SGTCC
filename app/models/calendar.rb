class Calendar < ApplicationRecord
  include Tcc

  validates :year, presence: true
  validates :semester, presence: true
  validates :tcc, presence: true

  enum semester: { one: 1, two: 2 }, _prefix: :semester

  def self.human_semesters
    hash = {}
    semesters.each_key { |key| hash[I18n.t("enums.tcc.#{key}")] = key }
    hash
  end
end
