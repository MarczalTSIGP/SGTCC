FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Post #{n}" }
    sequence(:url) { |n| "/path-#{n}" }
    content { Faker::Lorem.paragraph }
    fa_icon { 'home' }
  end
end
