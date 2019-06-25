class Signature < ApplicationRecord
  include KaminariHelper
  include Confirmable

  belongs_to :orientation
  belongs_to :document

  enum user_type: {
    advisor: 'AD',
    academic: 'AC',
    professor_supervisor: 'PS',
    external_member_supervisor: 'ES'
  }, _prefix: :user_type

  scope :with_relationships, lambda {
    includes(:orientation, document: [:document_type])
  }

  def sign
    self.status = true
    save
  end

  def confirm_and_sign(class_name, login, params)
    confirm(class_name, login, params) && sign
  end

  def term_of_commitment?
    document.document_type.id == DocumentType.find_by(name: I18n.t('signatures.documents.TCO'))&.id
  end

  def can_view(user, type)
    user.id == user_id && type == user_type
  end

  def professor_can_view(professor)
    can_view(professor, 'professor_supervisor') || can_view(professor, 'advisor')
  end

  def self.by_user_and_status(user, type, status)
    where(user_id: user.id, user_type: type, status: status).with_relationships
  end

  def self.by_professor_and_status(professor, status)
    by_user_and_status(professor, user_types[:professor_supervisor], status) +
      by_user_and_status(professor, user_types[:advisor], status)
  end

  def self.by_academic_and_status(academic, status)
    by_user_and_status(academic, user_types[:academic], status)
  end

  def self.by_external_member_and_status(external_member, status)
    by_user_and_status(external_member, user_types[:external_member_supervisor], status)
  end
end
