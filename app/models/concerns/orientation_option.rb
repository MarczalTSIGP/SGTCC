require 'active_support/concern'

module OrientationOption
  extend ActiveSupport::Concern

  included do
    def can_be_canceled?(professor)
      professor&.role?(:responsible) && active?
    end

    def can_be_edited?
      doc_type_ids = DocumentType.where(identifier: [:adpp, :adpj, :admg]).pluck(:id)
      documents.where(document_type: doc_type_ids).empty?
    end

    def can_be_destroyed?
      can_be_edited?
    end
  end
end
