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

    factory :document_type_tep do
      name { I18n.t('signatures.documents.TEP') }
      identifier { DocumentType.identifiers[:tep] }
    end

    factory :document_type_tso do
      name { I18n.t('signatures.documents.TSO') }
      identifier { DocumentType.identifiers[:tso] }
    end

    factory :document_type_adpp do
      name { I18n.t('signatures.documents.ADPP') }
      identifier { DocumentType.identifiers[:adpp] }
    end

    factory :document_type_adpj do
      name { I18n.t('signatures.documents.ADPJ') }
      identifier { DocumentType.identifiers[:adpj] }
    end

    factory :document_type_admg do
      name { I18n.t('signatures.documents.ADMG') }
      identifier { DocumentType.identifiers[:admg] }
    end
  end
end
