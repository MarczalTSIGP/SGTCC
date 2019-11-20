require 'active_support/concern'

module OrientationDocuments
  extend ActiveSupport::Concern

  included do
    def find_document_by_document_type(document_type)
      documents.find_by(document_type_id: document_type)
    end

    def tco
      find_document_by_document_type(DocumentType.tco)
    end

    def tcai
      find_document_by_document_type(DocumentType.tcai)
    end

    def tco?
      tco.present?
    end

    def tcai?
      tcai.present?
    end

    def destroy_document(document)
      document.signatures.destroy_all
      document.delete
    end
  end
end
