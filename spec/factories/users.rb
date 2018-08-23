FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@gmai.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
