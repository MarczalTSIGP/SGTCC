FactoryBot.define do
  factory :professor_type do
    sequence(:name) { |n| "name#{n}" }
  end
end
