FactoryBot.define do
  factory :activity_type do
    sequence(:name) { |n| "activity_type#{n}" }
  end
end
