class Activity < ApplicationRecord
  include Searchable

  searchable name: { unaccent: true }

  belongs_to :activity_type

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
