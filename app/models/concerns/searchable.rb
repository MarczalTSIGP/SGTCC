require 'active_support/concern'

module Searchable
  extend ActiveSupport::Concern

  module ClassMethods
    attr_reader :search_fields

    def search_joins(term)
      join_keys.where_search(query_search_joins(query_search), term)
    end

    def where_search(search, term)
      where(search, *["%#{term}%"] * search.count('?'))
    end

    private

    def searchable(*search_fields)
      @search_fields = search_fields
    end

    def query_search
      @search_fields.map do |field|
        query_from_string(field)
      end.join(' OR ')
    end

    def query_search_joins(search)
      hash_joins&.each do |table, field|
        table = field[:table_name] if field.key?(:table_name)
        field[:fields].each do |f|
          search += "#{query_from_string(f, table)} OR "
        end
      end
      search[0..search.length - 5]
    end

    def join_keys
      left_joins(hash_joins.keys).distinct if hash_joins
    end

    def query_unnacent_ilike(name, table = model_name.plural)
      "unaccent(#{table}.#{name}) ILIKE unaccent(?)"
    end

    def query_ilike(name, table = model_name.plural)
      "#{table}.#{name} ILIKE ?"
    end

    def query_from_options(field, table)
      field.map do |name, options|
        next if name.eql?(:relationships)

        query_from_unaccent(options, name, table)
      end.join(' OR ')
    end

    def query_from_unaccent(options, name, table)
      options[:unaccent] ? query_unnacent_ilike(name, table) : query_ilike(name, table)
    end

    def query_from_string(field, table = nil)
      table = table ? table.to_s.pluralize : model_name.plural
      return query_from_options(field, table) if field.is_a?(Hash)

      query_ilike(field, table)
    end
  end

  included do
    def self.search(term = nil)
      return all if term.blank?

      hash_joins ? search_joins(term) : where_search(query_search, term)
    end

    def self.hash_joins
      hash = @search_fields.last
      hash[:relationships] if hash.is_a?(Hash) && hash.key?(:relationships)
    end
  end
end
