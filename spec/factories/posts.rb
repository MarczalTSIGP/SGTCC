FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Post #{n}" }
    sequence(:url) { |n| "/path-#{n}" }
    content { Faker::Lorem.paragraph }
    fa_icon { 'home' }

    before :create do
      create(:site) if Site.all.empty?
    end
  end
end
