FactoryBot.define do
  factory :document do
    content { Faker::Lorem.paragraph }
    document_type
    signature_code
  end
end
