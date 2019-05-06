require 'active_support/concern'

module Semester
  extend ActiveSupport::Concern

  included do
    enum semester: { one: 1, two: 2 }, _prefix: :semester

    def self.human_semesters
      hash = {}
      semesters.each_key { |key| hash[I18n.t("enums.semester.#{key}")] = key }
      hash
    end
  end
end
