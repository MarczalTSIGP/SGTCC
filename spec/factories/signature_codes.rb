FactoryBot.define do
  factory :signature_code do
    sequence(:code) { |n| "code#{n}" }
  end
end
