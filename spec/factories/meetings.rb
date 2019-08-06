FactoryBot.define do
  factory :meeting do
    content { Faker::Lorem.paragraph }
    date { Faker::Date.forward(1) }
    orientation
  end
end
