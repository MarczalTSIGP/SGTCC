FactoryBot.define do
  factory :activity do
    sequence(:name) { |n| "activity#{n}" }
    activity_type
  end
end
