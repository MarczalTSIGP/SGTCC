FactoryBot.define do
  factory :document_type do
    sequence(:name) { |n| "document_type#{n}" }

    factory :document_type_tco do
      name { I18n.t('signatures.documents.TCO') }
    end

    factory :document_type_tcai do
      name { I18n.t('signatures.documents.TCAI') }
    end
  end
end
