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

  def confirm(class_name, login, params)
    class_name.find_by("#{login}": params[:login])&.valid_password?(params[:password])
  end

  def can_view(user, type)
    user.id == user_id && type == user_type
  end

  def self.by_user_and_status(user, type, status)
    where(user_id: user.id, user_type: type, status: status).with_relationships
  end

  def self.by_professor_and_status(professor, status)
    by_user_and_status(professor, 'P', status)
  end

  def self.by_academic_and_status(academic, status)
    by_user_and_status(academic, 'A', status)
  end

  def self.by_external_member_and_status(external_member, status)
    by_user_and_status(external_member, 'E', status)
  end
end
