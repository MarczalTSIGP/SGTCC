FactoryBot.define do
  factory :document do
    content { Faker::Lorem.paragraph }
    document_type
  end
end
