FactoryBot.define do
  factory :base_activity_type do
    sequence(:name) { |n| "base_activity_type#{n}" }
    identifier { :send_document }
  end
end
