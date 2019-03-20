require 'active_support/concern'

module Classifiable
  extend ActiveSupport::Concern

  included do
    def self.human_genders
      hash = {}
      genders.each_key { |key| hash[I18n.t("enums.genders.#{key}")] = key }
      hash
    end
  end
end
