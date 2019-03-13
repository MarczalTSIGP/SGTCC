FactoryBot.define do
  factory :institution do
    sequence(:name) { Faker::Name.name }
    sequence(:trade_name) { Faker::Name.name }
    cnpj { Faker::Number.number(2) }
    external_member
  end
end
