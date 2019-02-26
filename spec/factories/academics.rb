FactoryBot.define do
  factory :academic do
    sequence(:name) { Faker::Name.name }
    sequence(:email) { |n| "email#{n}@email.com" }
    ra { Faker::Number.number(7) }
    gender { Academic.genders.values.sample }
  end
end
