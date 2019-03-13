FactoryBot.define do
  factory :external_member do
    sequence(:name) { |n| "External member #{n}" }
    sequence(:email) { |n| "externalmember#{n}@gmail.com" }
    gender { ExternalMember.genders.values.sample }
    is_active { Faker::Boolean.boolean }
    working_area { Faker::Markdown.headers }
  end
end