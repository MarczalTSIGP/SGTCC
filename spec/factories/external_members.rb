FactoryBot.define do
  factory :external_member do
    sequence(:name) { |n| "External member #{n}" }
    sequence(:email) { |n| "externalmember#{n}@gmail.com" }
    sequence(:personal_page) { |n| "http://page.com.#{n}" }
    gender { ExternalMember.genders.values.sample }
    is_active { Faker::Boolean.boolean }
    working_area { Faker::Markdown.headers }
    professor_title
  end
end
