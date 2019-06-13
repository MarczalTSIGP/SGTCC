class Document < ApplicationRecord
  validates :content, presence: true

  belongs_to :document_type
end
