FactoryBot.define do
  factory :meeting do
    sequence(:title) { |n| "meeting#{n}" }
    content { Faker::Lorem.paragraph }
    orientation
  end
end
