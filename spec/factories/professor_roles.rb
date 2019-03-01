FactoryBot.define do
  factory :professor_role do
    sequence(:name) { |n| "name#{n}" }
  end
end
