require 'active_support/concern'

module OrientationOption
  extend ActiveSupport::Concern

  included do
    def can_be_renewed?(professor)
      professor&.role?(:responsible) && calendar_tcc_two? && in_progress?
    end

    def can_be_canceled?(professor)
      professor&.role?(:responsible) && active?
    end

    def can_be_edited?
      signatures.where(status: true).empty?
    end

    def can_be_destroyed?
      tcos = signatures.by_document_type(DocumentType.tco)
      tcais = signatures.by_document_type(DocumentType.tcai)

      all_signed_tco = tcos.where(status: true).count < tcos.count

      tcais_to_sign = tcais.count
      return all_signed_tco unless tcais_to_sign.positive?

      all_signed_tcai = tcais.where(status: true).count < tcais_to_sign
      all_signed_tco && all_signed_tcai
    end
  end
end
