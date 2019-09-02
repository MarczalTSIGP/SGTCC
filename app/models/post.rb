class Post < ApplicationRecord
  include Searchable

  searchable title: { unaccent: true }

  validates :url, presence: true
  validates :title, presence: true
  validates :fa_icon, presence: true
  validates :content, presence: true
end
