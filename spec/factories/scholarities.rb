FactoryBot.define do
  factory :scholarity do
    sequence(:name) { |n| "name#{n}" }
    sequence(:abbr) { |n| "abbr#{n}" }
  end
end
