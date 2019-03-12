FactoryBot.define do
  factory :role do
    sequence(:name) { |n| "name#{n}" }
  end
end
