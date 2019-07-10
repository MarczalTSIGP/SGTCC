class Document < ApplicationRecord
  validates :content, presence: true

  belongs_to :signature_code
  belongs_to :document_type

  has_many :signatures, dependent: :destroy

  def all_signed?
    return false if signatures.empty?
    signatures.where(status: true).count == signatures.count
  end
end
