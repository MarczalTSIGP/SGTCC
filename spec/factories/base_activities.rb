FactoryBot.define do
  factory :base_activity do
    sequence(:name) { |n| "activity#{n}" }
    base_activity_type
  end
end
