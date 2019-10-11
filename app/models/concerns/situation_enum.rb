require 'active_support/concern'

module SituationEnum
  extend ActiveSupport::Concern

  included do
    enum situation: {
      approved: 'approved',
      reproved: 'reproved',
      not_appear: 'not_appear',
      under_evaluation: 'under_evaluation'
    }
  end
end
