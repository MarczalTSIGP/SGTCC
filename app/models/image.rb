class Image < ApplicationRecord
  include Searchable

  mount_uploader :url, ImageUploader

  searchable :name
end
