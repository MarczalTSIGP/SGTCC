class Document < ApplicationRecord
  include TermJsonData
  include SignatureMark

  attr_accessor :orientation_id, :justification

  belongs_to :document_type

  has_many :signatures, dependent: :destroy

  validates :justification, :orientation_id, presence: true, if: -> { document_type.tdo? }
  validates :justification, presence: true, if: -> { document_type.tep? }

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
    new_request(professor, 'advisor', document)
  end

  def self.new_tep(academic, params = {})
    params[:orientation_id] = academic.current_orientation_tcc_two.first.id
    document = DocumentType.find_by(identifier: :tep).documents.new(params)
    new_request(academic, 'academic', document)
  end

  def self.new_request(user, user_type, document)
    document.request = { requester: { id: user.id, name: user.name,
                                      type: user_type, justification: document.justification } }
    document
  end

  private

  def create_signatures
    Documents::SaveSignatures.new(self).send("save_#{document_type.identifier}")
  end

  def generate_unique_code
    update(code: Time.now.to_i + id)
  end
end
