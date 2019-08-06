FactoryBot.define do
  factory :document_type do
    sequence(:name) { |n| "document_type#{n}" }
    identifier { DocumentType.identifiers.values.sample }

    factory :document_type_tco do
      name { I18n.t('signatures.documents.TCO') }
      identifier { DocumentType.identifiers[:tco] }
    end

    factory :document_type_tdo do
      name { I18n.t('signatures.documents.TDO') }
      identifier { DocumentType.identifiers[:tdo] }
    end

    factory :document_type_tcai do
      name { I18n.t('signatures.documents.TCAI') }
      identifier { DocumentType.identifiers[:tcai] }
    end
  end
end
