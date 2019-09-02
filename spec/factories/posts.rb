FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Post #{n}" }
    content { Faker::Lorem.paragraph }
  end
end
