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
    external_member_supervisor: 'ES',
    professor_evaluator: 'PV',
    external_member_evaluator: 'EMV',
    responsible_institution: 'RI'
  }, _prefix: :user_type

  scope :by_document_type, lambda { |document_type_id|
    joins(:document).where(documents: { document_type_id: })
  }

  scope :recent, -> { order(created_at: :desc) }

  def sign
    update(status: true)
  end

  def user_table
    return Academic if user_type == 'academic'

    ems = %w[external_member_supervisor external_member_evaluator responsible_institution]

    if ems.include? user_type
      ExternalMember
    else
      Professor
    end
  end

  def user
    user_table.find(user_id)
  end
end
