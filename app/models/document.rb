class Document < ApplicationRecord
  validates :content, presence: true

  belongs_to :document_type

  has_many :signatures, dependent: :destroy

  validates :code, presence: true, uniqueness: true

  def all_signed?
    signatures.where(status: true).count == signatures.count
  end
end
