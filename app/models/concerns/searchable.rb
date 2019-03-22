require 'active_support/concern'

module Searchable
  extend ActiveSupport::Concern

  included do
    def self.search(term = nil, search_fields = [], order_by = 'name ASC')
      return order(order_by) if term.blank?

      search = search_fields.map do |field, value|
        get_query_string(field, value)
      end.join(' OR ')

      where(search, *["%#{term}%"] * search_fields.count).order(order_by)
    end

    def self.get_query_string(field, value)
      value[:unaccent] ? "unaccent(#{field}) ILIKE unaccent(?)" : "#{field} ILIKE ?"
    end
  end
end
