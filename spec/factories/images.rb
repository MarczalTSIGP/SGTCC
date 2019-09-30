FactoryBot.define do
  factory :image do
    sequence(:name) { Faker::Name.name }
    sequence(:url) { Faker::Name.name }
  end
end
