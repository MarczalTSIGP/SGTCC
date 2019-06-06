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
      return search_joins(term) if join_keys
      where_search(query_search, term)
    end

    def self.search_joins(term)
      join_keys.where_search(query_search_joins(query_search), term)
    end

    def self.query_search
      @search_fields.map do |field|
        query_from_string(field)
      end.join(' OR ')
    end

    def self.query_search_joins(search)
      hash_joins&.each do |_, field|
        field[:fields].each do |f|
          search += "#{query_from_string(f, field[:table_name])} OR "
        end
      end
      search[0..search.length - 5]
    end

    def self.hash_joins
      hash = @search_fields.last
      hash[:joins] if hash.key?(:joins)
    end

    def self.join_keys
      joins(hash_joins.keys) if hash_joins
    end

    def self.where_search(search, term)
      where(search, *["%#{term}%"] * search.count('?'))
    end

    def self.query_unnacent_ilike(name, table = table_name)
      "unaccent(#{table}.#{name}) ILIKE unaccent(?)"
    end

    def self.query_ilike(name, table = table_name)
      "#{table}.#{name} ILIKE ?"
    end

    def self.table_name
      model_name.plural
    end

    def self.query_from_options(field, table)
      search = field.map do |name, options|
        next if name.eql?(:joins)
        options[:unaccent] ? query_unnacent_ilike(name, table) : query_ilike(name, table)
      end.join(' OR ')
      search
    end

    def self.query_from_string(field, table = nil)
      table = table ? table.to_s.pluralize : table_name
      return query_from_options(field, table) if field.is_a?(Hash)
      query_ilike(field, table)
    end
  end
end
