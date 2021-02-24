FactoryBot.define do
  factory :academic do
    sequence(:name) { Faker::Name.name }
    sequence(:email) { |n| "email#{n}@email.com" }
    ra { Faker::Number.number(digits: 7) }
    gender { Academic.genders.values.sample }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
