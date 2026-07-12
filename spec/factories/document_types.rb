FactoryBot.define do
  document_types = {
    tco: 'TCO',
    tdo: 'TDO',
    tcai: 'TCAI',
    tep: 'TEP',
    tso: 'TSO',
    adpp: 'ADPP',
    adpj: 'ADPJ',
    admg: 'ADMG'
  }.freeze

  factory :document_type do
    sequence(:name) { |n| "document_type#{n}" }
    identifier { DocumentType.identifiers.values.sample }

    document_types.each do |identifier, translation_key|
      factory :"document_type_#{identifier}" do
        name { I18n.t("signatures.documents.#{translation_key}") }
        identifier { DocumentType.identifiers[identifier] }
      end
    end
  end
end
