FactoryBot.define do
  factory :orientation do
    title { Faker::Lorem.sentence(3) }
    calendar
    academic
    professor
    institution
  end
end
