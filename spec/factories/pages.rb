FactoryBot.define do
  factory :page do
    sequence(:menu_title) { |n| "Page #{n}" }
    url { Faker::Name.unique.first_name.parameterize }
    content { Faker::Lorem.paragraph }
    fa_icon { 'fas fa-home' }
    publish { true }

    before :create do
      create(:site) if Site.all.empty?
    end
  end
end
