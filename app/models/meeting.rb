class Meeting < ApplicationRecord
  include Searchable

  searchable title: { unaccent: true }

  belongs_to :orientation

  validates :title,
            presence: true

  validates :content,
            presence: true
end
