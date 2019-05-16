require 'active_support/concern'

module StringHelper
  extend ActiveSupport::Concern

  included do
    def self.remove_accents(string)
      I18n.transliterate(string)
    end
  end
end
