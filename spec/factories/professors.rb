FactoryBot.define do
  factory :professor do
    sequence(:email) { |n| "professor#{n}@gmail.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
