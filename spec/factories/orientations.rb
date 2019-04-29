FactoryBot.define do
  factory :orientation do
    title { Faker::Lorem.sentence(3) }
    advisor { create(:professor) }
    calendar
    academic
    institution
  end
end
