FactoryBot.define do
  factory :document do
    content { Faker::Lorem.paragraph }
    sequence(:code) { |n| "code#{n}" }
    document_type
  end
end
