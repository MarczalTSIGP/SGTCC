class Document < ApplicationRecord
  validates :content, presence: true

  belongs_to :document_type

  has_many :signatures, dependent: :destroy

  include TermJsonData

  store_accessor :request, :justification

  attr_accessor :orientation

  after_create do
    update(code: Time.now.to_i + id)
  end

  after_save do
    if document_type.tdo? && content.size == 1
      Documents::SaveTdoSignatures.new(self, orientation).save
      update_content_data
    end
  end

  def first_orientation
    signatures.first.orientation
  end

  def all_signed?
    signatures.where(status: true).count == signatures.count
  end

  def update_content_data
    update(content: term_json_data)
  end

  def self.create_tdo(professor, justification, orientation)
    request = { requester: { id: professor.id, name: professor.name,
                             type: 'advisor', justification: justification } }

    document = DocumentType.tdo.first.documents.new(content: '-', request: request)
    document.orientation = orientation
    document.save
  end
end
