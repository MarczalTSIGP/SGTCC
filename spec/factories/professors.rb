FactoryBot.define do
  factory :professor do
    sequence(:email) { |n| "professor#{n}@gmai.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
