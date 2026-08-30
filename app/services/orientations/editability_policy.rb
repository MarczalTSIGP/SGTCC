module Orientations
  class EditabilityPolicy
    PROTECTED_DOCUMENT_IDENTIFIERS = [:adpp, :adpj, :admg].freeze

    def initialize(orientation)
      @orientation = orientation
    end

    def editable?
      protected_ids = DocumentType.where(identifier: PROTECTED_DOCUMENT_IDENTIFIERS).pluck(:id)
      @orientation.documents.where(document_type: protected_ids).empty?
    end

    alias destroyable? editable?
  end
end
