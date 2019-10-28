class AttachedDocument < ApplicationRecord
  include Searchable

  searchable name: { unaccent: true }

  mount_uploader :file, FileUploader

  validates :name,
            presence: true

  validates :file,
            presence: true
end
