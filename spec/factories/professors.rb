FactoryBot.define do
  factory :professor do
    sequence(:name) { |n| "Professor #{n}" }
    sequence(:username) { |n| "professor#{n}" }
    sequence(:email) { |n| "professor#{n}@gmail.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
