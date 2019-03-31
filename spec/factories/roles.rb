FactoryBot.define do
  factory :role do
    name { |n| "name#{n}" }
    identifier { |n| "identifier#{n}" }
  end
end
