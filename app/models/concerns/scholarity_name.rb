require 'active_support/concern'

module ScholarityName
  extend ActiveSupport::Concern

  included do
    def name_with_scholarity
      "#{scholarity.abbr} #{name}"
    end
  end
end
