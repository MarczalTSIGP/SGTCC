class Document < ApplicationRecord
  validates :content, presence: true

  belongs_to :document_type

  has_many :signatures, dependent: :destroy

  include TermJsonData

  after_create do
    update(code: Time.now.to_i + id)
  end

  def all_signed?
    signatures.where(status: true).count == signatures.count
  end

  def update_content_data
    update(content: term_json_data)
  end
end
