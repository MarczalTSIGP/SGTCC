require 'active_support/concern'

module Semester
  extend ActiveSupport::Concern

  included do
    enum :semester, I18n.t('enums.tcc_number'), prefix: :semester

    def self.human_semesters
      hash = {}
      semesters.each_key { |key| hash[I18n.t("enums.semester.#{key}")] = key }
      hash
    end
  end
end
