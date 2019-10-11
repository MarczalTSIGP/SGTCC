require 'active_support/concern'

module SituationEnum
  extend ActiveSupport::Concern

  included do
    enum situation: {
      approved: I18n.t('enums.situation.approved'),
      reproved: I18n.t('enums.situation.reproved'),
      not_appear: I18n.t('enums.situation.not_appear'),
      under_evaluation: I18n.t('enums.situation.under_evaluation')
    }

    def self.human_situations
      hash = {}
      situations.each_key { |key| hash[I18n.t("enums.situation.#{key}")] = key }
      hash
    end
  end
end
