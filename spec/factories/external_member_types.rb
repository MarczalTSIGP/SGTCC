FactoryBot.define do
  factory :external_member_type do
    sequence(:name) { |n| "External member type#{n}" }
  end
end
