class BaseActivity < ApplicationRecord
  include Searchable

  searchable name: { unaccent: true }

  belongs_to :base_activity_type

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
