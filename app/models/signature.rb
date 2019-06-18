class Signature < ApplicationRecord
  include KaminariHelper

  belongs_to :orientation
  belongs_to :document

  enum user_type: { professor: 'P', academic: 'A', external_member: 'E' }, _prefix: :user_type

  scope :with_relationships, lambda {
    includes(:orientation, document: [:document_type])
  }

  def sign
    self.status = true
    save
  end

  def self.by_professor_and_status(professor, status)
    where(user_id: professor.id, user_type: 'P', status: status).with_relationships
  end

  def self.by_academic_and_status(academic, status)
    where(user_id: academic.id, user_type: 'A', status: status).with_relationships
  end
end
