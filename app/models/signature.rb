class Signature < ApplicationRecord
  belongs_to :orientation
  belongs_to :document

  enum :user_type, {
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
  }, prefix: :user_type

  scope :by_document_type, lambda { |document_type_id|
    joins(:document).where(documents: { document_type_id: })
  }

  scope :recent, -> { order(created_at: :desc) }

  def sign
    update(status: true)
  end

  def user_table
    return Academic if user_type_academic?
    return ExternalMember if external_member_user_type?

    Professor
  end

  def user
    user_table.find(user_id)
  end

  private

  def external_member_user_type?
    user_type_external_member_supervisor? || user_type_external_member_evaluator? ||
      user_type_responsible_institution?
  end
end
