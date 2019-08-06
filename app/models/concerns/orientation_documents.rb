require 'active_support/concern'

module OrientationDocuments
  extend ActiveSupport::Concern

  included do
    after_save do
      params = { orientation_id: id }
      DocumentType.find_by(identifier: :tco).documents.create!(params)
      DocumentType.find_by(identifier: :tcai).documents.create!(params) if institution.present?
    end

    after_update do
      document_ids = signatures.pluck(:document_id)
      signatures.destroy_all
      Document.delete(document_ids)
    end
  end
end
