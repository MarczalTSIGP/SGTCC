FactoryBot.define do
  factory :base_activity_type do
    sequence(:name) { |n| "activity_type#{n}" }
  end
end
