require 'active_support/concern'

module OrientationDocuments
  extend ActiveSupport::Concern

  included do
    after_save do
      create_term_of_commitment_signatures
      create_term_of_accept_institution_signatures if institution.present?
    end

    after_update do
      document_ids = signatures.map { |signature| signature.document.id }
      signatures.destroy_all
      document_ids.each { |document_id| Document.delete(document_id) }
    end

    private

    def create_document(document_type)
      timestamps = Time.now.to_i + id
      Document.create(content: '-', code: timestamps, document_type_id: document_type&.id)
    end

    def create_term_signatures(document)
      Documents::SaveSignatures.new(self, document).save
    end

    def create_term_of_commitment_signatures
      document = create_document(DocumentType.find_by(identifier: DocumentType.identifiers[:tco]))
      create_term_signatures(document)
    end

    def create_term_of_accept_institution_signatures
      document = create_document(DocumentType.find_by(identifier: DocumentType.identifiers[:tcai]))
      create_term_signatures(document)
    end
  end
end
