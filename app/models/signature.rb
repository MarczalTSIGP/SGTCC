class Signature < ApplicationRecord
  include Confirmable
  include SignatureMark

  belongs_to :orientation
  belongs_to :document

  enum user_type: {
    advisor: 'AD',
    academic: 'AC',
    professor_supervisor: 'PS',
    external_member_supervisor: 'ES'
  }, _prefix: :user_type

  scope :with_relationships, lambda {
    includes(orientation: [:academic], document: [:document_type])
  }

  scope :by_document_type, lambda { |document_type_id|
    joins(:document).where(documents: { document_type_id: document_type_id })
  }

  def sign
    self.status = true
    save
  end

  def confirm_and_sign(class_name, login, params)
    confirm(class_name, login, params) && sign
  end

  def term_of_commitment?
    document.document_type.tco?
  end

  def term_of_accept_institution?
    document.document_type.tcai?
  end

  def user_table
    return Academic if user_type == 'academic'
    return ExternalMember if user_type == 'external_member_supervisor'
    Professor
  end

  def user
    user_table.find(user_id)
  end

  def self.by_orientation_and_document_t(orientation_id, document_type_id)
    by_document_type(document_type_id).where(orientation_id: orientation_id)
  end

  def self.status_table(orientation_id, document_type_id)
    signatures = by_orientation_and_document_t(orientation_id, document_type_id)
    signatures.map do |signature|
      { name: signature.user.name, status: signature.status }
    end
  end
end
