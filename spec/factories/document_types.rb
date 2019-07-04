FactoryBot.define do
  factory :document_type do
    sequence(:name) { |n| "document_type#{n}" }
    identifier { |n| "identifier#{n}" }

    factory :document_type_tco do
      name { I18n.t('signatures.documents.TCO') }
      identifier { 'tco' }
    end

    factory :document_type_tcai do
      name { I18n.t('signatures.documents.TCAI') }
      identifier { 'tcai' }
    end
  end
end
