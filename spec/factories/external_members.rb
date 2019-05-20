FactoryBot.define do
  factory :external_member do
    sequence(:name) { |n| "External member #{n}" }
    sequence(:email) { |n| "externalmember#{n}@gmail.com" }
    sequence(:personal_page) { |n| "https://www.page#{n}.com.br" }
    gender { ExternalMember.genders.values.sample }
    is_active { Faker::Boolean.boolean }
    working_area { Faker::Markdown.headers }
    scholarity
    password { 'password' }
    password_confirmation { 'password' }

    factory :external_member_inactive do
      is_active { false }
    end
  end
end
