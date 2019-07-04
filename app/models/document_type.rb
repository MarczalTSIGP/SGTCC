class DocumentType < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :documents, dependent: :destroy

  validates :identifier, presence: true, uniqueness: { case_sensitive: false }
end
