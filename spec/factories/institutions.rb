FactoryBot.define do
  factory :institution do
    sequence(:name) { |n| "Institution #{n}" }
    sequence(:trade_name) { |n| "institution#{n}" }
    cnpj { Faker::Number.number(14) }
    external_member
  end
end
