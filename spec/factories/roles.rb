FactoryBot.define do
  factory :role do
    name { |n| "name#{n}" }
  end
end
