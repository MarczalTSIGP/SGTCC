require 'active_support/concern'

module OrientationTcoTcai
  extend ActiveSupport::Concern

  included do
    after_save do
      if calendar_tcc_one?
        params = { orientation_id: id }
        create_tco(params) unless tco?
        create_tcai(params) unless tcai?
      end
    end

    after_update do
      destroy_document(tco) if tco?
      destroy_document(tcai) if tcai?
    end

    def create_tco(params)
      DocumentType.find_by(identifier: :tco).documents.create!(params)
    end

    def create_tcai(params)
      DocumentType.find_by(identifier: :tcai).documents.create!(params) if institution.present?
    end
  end
end
