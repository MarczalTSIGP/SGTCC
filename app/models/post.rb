class Post < ApplicationRecord
  include Searchable

  searchable title: { unaccent: true }

  validates :title, presence: true
  validates :content, presence: true
end
