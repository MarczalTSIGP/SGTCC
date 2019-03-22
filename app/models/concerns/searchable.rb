require 'active_support/concern'

module Searchable
  extend ActiveSupport::Concern

  included do
    def self.search(term = nil, search_fields = [], order_by = 'name ASC')
      return order(order_by) if term.blank?

      search = search_fields.map do |name, value|
        value[:unaccent] ? "unaccent(#{name}) ILIKE unaccent(?)" : "#{name} ILIKE ?"
      end.join(' OR ')

      where(search, *["%#{term}%"] * search_fields.count).order(order_by)
    end
  end
end
