require 'active_support/concern'

module OrientationDocuments
  extend ActiveSupport::Concern

  included do
    after_save do
      term_of_commitment = DocumentType.find_by(name: I18n.t('signatures.documents.TCO'))
      term_of_accept_institution = DocumentType.find_by(name: I18n.t('signatures.documents.TCAI'))
      Documents::SaveSignatures.new(self, term_of_commitment&.id).save
      Documents::SaveSignatures.new(self, term_of_accept_institution&.id).save
    end

    after_update do
      signatures.destroy_all
    end
  end
end
