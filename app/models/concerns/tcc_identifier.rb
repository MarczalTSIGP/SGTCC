require 'active_support/concern'

module TccIdentifier
  extend ActiveSupport::Concern

  included do
    enum identifier: {
      proposal: 'proposal',
      project: 'project',
      monograph: 'monograph'
    }

    def self.human_tcc_identifiers
      hash = {}
      identifiers.each_key { |key| hash[I18n.t("enums.tcc.identifiers.#{key}")] = key }
      hash
    end

    def self.human_tcc_one_identifiers
      human_identifiers.first(2).to_h
    end
  end
end
