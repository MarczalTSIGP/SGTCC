require 'active_support/concern'

module Searchable
  extend ActiveSupport::Concern

  included do
    def self.search(search = nil)
      if search
        where(query_str, "%#{search}%", "%#{search}%", "%#{search}%")
          .order('name ASC')
      else
        order(:name)
      end
    end

    def self.query_str
      if table_name == 'academics'
        'unaccent(name) ILIKE unaccent(?) OR email ILIKE ? OR ra ILIKE ?'
      elsif table_name == 'professors'
        'unaccent(name) ILIKE unaccent(?) OR email ILIKE ? OR username ILIKE ?'
      elsif table_name == 'external_members'
        'unaccent(name) ILIKE unaccent(?) OR email ILIKE ? OR working_area ILIKE ?'
      else
        'unaccent(trade_name) ILIKE unaccent(?) OR company_name ILIKE ? OR cnpj ILIKE ?'
      end
    end
  end
end
