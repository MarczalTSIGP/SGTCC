require 'active_support/concern'

module Searchable
  extend ActiveSupport::Concern

  module ClassMethods
    attr_reader :search_fields

    private

    def searchable(*search_fields)
      @search_fields = search_fields
    end
  end

  included do
    def self.search(term = nil)
      return all if term.blank?

      search = @search_fields.map do |field|
        query_from_string(field)
      end.join(' OR ')

      where(search, *["%#{term}%"] * search.count('?'))
    end

    def self.query_from_string(field)
      if field.is_a?(Hash)
        search = field.map do |name, options|
          options[:unaccent] ? "unaccent(#{name}) ILIKE unaccent(?)" : "#{name} ILIKE ?"
        end.join(' OR ')
        return search
      end
      "#{field} ILIKE ?"
    end
  end
end
