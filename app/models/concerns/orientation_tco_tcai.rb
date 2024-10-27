require 'active_support/concern'

module OrientationTcoTcai
  extend ActiveSupport::Concern

  included do
    after_create_commit :create_tco_and_tcai
    after_update :recreate_tco_and_tcai

    def create_tco(params)
      DocumentType.find_by(identifier: :tco).documents.create!(params)
    end

    def create_tcai(params)
      DocumentType.find_by(identifier: :tcai).documents.create!(params) if institution.present?
    end

    private

    def create_tco_and_tcai
      params = { orientation_id: id }
      create_tco(params)
      create_tcai(params)
    end

    def recreate_tco_and_tcai
      return unless tcc_one? && can_be_edited?

      destroy_document(tco) if tco?
      destroy_document(tcai) if tcai?

      create_tco_and_tcai
    end
  end
end
