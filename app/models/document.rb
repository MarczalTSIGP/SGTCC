class Document < ApplicationRecord
  include TermJsonData
  include SignatureMark

  attr_accessor :orientation_id, :justification

  belongs_to :document_type

  has_many :signatures, dependent: :destroy

  validates :justification, :orientation_id, presence: true, if: -> { document_type.tdo? }

  after_create :generate_unique_code,
               :create_signatures,
               :save_to_json

  def orientation
    signatures.first.orientation
  end

  def all_signed?
    signatures.where(status: true).count == signatures.count
  end

  def save_to_json
    update(content: term_json_data)
  end

  def status_table
    signatures.map do |signature|
      { name: signature.user.name, status: signature.status }
    end
  end

  def self.new_tdo(professor, params = {})
    document = DocumentType.find_by(identifier: :tdo).documents.new(params)
    document.request = { requester: { id: professor.id, name: professor.name,
                                      type: 'advisor', justification: document.justification } }
    document
  end

  private

  def create_signatures
    documents = Documents::SaveSignatures.new(self)
    return documents.save_tco if document_type.tco?
    return documents.save_tcai if document_type.tcai?

    documents.save_tdo
  end

  def generate_unique_code
    update(code: Time.now.to_i + id)
  end
end
