require 'active_support/concern'

module OrientationTcoTcai
  extend ActiveSupport::Concern

  included do
    after_save do
      if calendar_tcc_one?
        params = { orientation_id: id }
        DocumentType.find_by(identifier: :tco).documents.create!(params) unless tco?

        if institution.present? && !tcai?
          DocumentType.find_by(identifier: :tcai).documents.create!(params)
        end
      end
    end

    after_update do
      destroy_document(tco) if tco?
      destroy_document(tcai) if tcai?
    end
  end
end
