require 'active_support/concern'

module OrientationDocuments
  extend ActiveSupport::Concern

  included do
    after_save do
      create_term_of_commitment_signatures
      create_term_of_accept_institution_signatures if institution.present?
    end

    after_update do
      destroy_signatures
    end

    private

    def create_term_signatures(term)
      Documents::SaveSignatures.new(self, term&.id).save
    end

    def create_term_of_commitment_signatures
      create_term_signatures(DocumentType.find_by(identifier: 'tco'))
    end

    def create_term_of_accept_institution_signatures
      create_term_signatures(DocumentType.find_by(identifier: 'tcai'))
    end

    def destroy_signatures
      signatures.destroy_all
    end
  end
end
