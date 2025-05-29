require 'active_support/concern'

module Tcc
  extend ActiveSupport::Concern

  included do
    enum :tcc, I18n.t('enums.tcc_number'), prefix: :tcc

    def self.human_tccs
      hash = {}
      tccs.each_key { |key| hash[I18n.t("enums.tcc.#{key}")] = key }
      hash
    end
  end
end
