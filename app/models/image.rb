class Image < ApplicationRecord
  include Searchable

  mount_uploader :url, ImageUploader

  searchable :name

  validates :name,
            presence: true

  validates :url,
            presence: true
end
