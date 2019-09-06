FactoryBot.define do
  factory :page do
    sequence(:menu_title) { |n| "Page #{n}" }
    url { Faker::Name.first_name.parameterize }
    content { Faker::Lorem.paragraph }
    fa_icon { 'home' }

    before :create do
      create(:site) if Site.all.empty?
    end
  end
end
