class Signature < ApplicationRecord
  belongs_to :orientation
  belongs_to :document

  enum user_type: {
    advisor: 'AD',
    academic: 'AC',
    coordinator: 'CC',
    new_advisor: 'NAD',
    professor_responsible: 'PR',
    professor_supervisor: 'PS',
    external_member_supervisor: 'ES'
  }, _prefix: :user_type

  scope :by_document_type, lambda { |document_type_id|
    joins(:document).where(documents: { document_type_id: document_type_id })
  }

  scope :recent, -> { order(created_at: :desc) }

  def sign
    update(status: true)
  end

  def user_table
    return Academic if user_type == 'academic'
    return ExternalMember if user_type == 'external_member_supervisor'
    Professor
  end

  def user
    user_table.find(user_id)
  end
end
