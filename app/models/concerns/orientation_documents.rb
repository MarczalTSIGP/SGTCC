require 'active_support/concern'

module OrientationDocuments
  extend ActiveSupport::Concern

  included do
    after_save do
      Documents::SaveSignatures.new(self).save
    end

    after_update do
      document_ids = signatures.pluck(:document_id)
      signatures.destroy_all
      document_ids.each { |document_id| Document.delete(document_id) }
    end
  end
end
