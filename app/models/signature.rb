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

  def sign
    self.status = true
    save
  end

  def confirm_and_sign(class_name, login, params)
    confirm(class_name, login, params) && sign
  end

  def equal_term?(term)
    document.document_type.id == term&.id
  end

  def term_of_commitment?
    equal_term?(DocumentType.find_by(name: I18n.t('signatures.documents.TCO')))
  end

  def term_of_accept_institution?
    equal_term?(DocumentType.find_by(name: I18n.t('signatures.documents.TCAI')))
  end

  def user_table
    return Academic if user_type == 'academic'
    return ExternalMember if user_type == 'external_member_supervisor'
    Professor
  end

  def user
    user_table.find(user_id)
  end

  def self.by_condition_and_document_t(condition, document_type_id)
    where(condition).includes(document: [:document_type]).select do |signature|
      signature.document.document_type.id == document_type_id.to_i
    end
  end

  def self.status_table(orientation_id, document_type_id)
    signatures = by_condition_and_document_t({ orientation_id: orientation_id }, document_type_id)
    signatures.map do |signature|
      { name: signature.user.name, status: signature.status }
    end
  end
end
