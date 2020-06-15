FactoryBot.define do
  factory :meeting do
    content { Faker::Lorem.paragraph }
    date { Faker::Date.forward(days: 1) }
    orientation
  end
end
