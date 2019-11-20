require 'active_support/concern'

module OrientationDocuments
  extend ActiveSupport::Concern

  included do
    after_save do
      params = { orientation_id: id }

      DocumentType.find_by(identifier: :tco).documents.create!(params) unless tco?

      if institution.present? && !tcai?
        DocumentType.find_by(identifier: :tcai).documents.create!(params)
      end
    end

    after_update do
      document_ids = signatures.pluck(:document_id)
      signatures.destroy_all
      Document.delete(document_ids)
    end

    def tco?
      documents.find_by(document_type_id: DocumentType.tco).present?
    end

    def tcai?
      documents.find_by(document_type_id: DocumentType.tcai).present?
    end
  end
end
