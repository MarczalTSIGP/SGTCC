FactoryBot.define do
  factory :document_type do
    sequence(:name) { |n| "document_type#{n}" }
  end
end
