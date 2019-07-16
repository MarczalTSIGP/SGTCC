class Document < ApplicationRecord
  validates :content, presence: true

  belongs_to :document_type

  has_many :signatures, dependent: :destroy

  include TermJsonData

  after_create do
    update(code: Time.now.to_i + id)
  end

  def first_orientation
    signatures.first.orientation
  end

  def orientation_data
    orientation = signatures.find_by(user_type: :advisor).orientation
    { id: orientation.id, title: orientation.title,
      abandonment_justification: orientation.abandonment_justification,
      created_at: I18n.l(orientation.created_at, format: :document) }
  end

  def all_signed?
    signatures.where(status: true).count == signatures.count
  end

  def update_content_data
    update(content: term_json_data)
  end
end
