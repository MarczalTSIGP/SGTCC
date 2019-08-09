FactoryBot.define do
  factory :document do
    content { Faker::Lorem.paragraph }
    sequence(:code) { |n| "code#{n}" }
    document_type

    factory :document_tco do
      document_type { create(:document_type_tco) }
    end

    factory :document_tdo do
      document_type { create(:document_type_tdo) }
      justification { 'justification' }
      request { '{"requester":{ "justification":"dsds" }' }
    end

    factory :document_tep do
      document_type { create(:document_type_tep) }
      justification { 'justification' }
      request { '{"requester":{ "justification":"dsds" }' }
    end

    factory :document_tso do
      document_type { create(:document_type_tso) }
      justification { 'justification' }
      request { '{"requester":{ "justification":"dsds" }' }
    end

    factory :document_tcai do
      document_type { create(:document_type_tcai) }
    end
  end
end
