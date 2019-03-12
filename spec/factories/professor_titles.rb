FactoryBot.define do
  factory :professor_title do
    sequence(:name) { |n| "name#{n}" }
    sequence(:abbr) { |n| "abbr#{n}" }
  end
end
