class Meeting < ApplicationRecord
  include Searchable

  searchable title: { unaccent: true }

  belongs_to :orientation

  validates :title,
            presence: true

  validates :content,
            presence: true

  scope :with_relationship, -> { includes(:orientation) }
end
