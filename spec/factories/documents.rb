FactoryBot.define do
  factory :document do
    content { Faker::Lorem.paragraph }
    sequence(:code) { |n| "code#{n}" }
    document_type

    factory :document_tco do
      document_type { create(:document_type_tco) }
    end

    factory :document_tcai do
      document_type { create(:document_type_tcai) }
    end
  end
end
