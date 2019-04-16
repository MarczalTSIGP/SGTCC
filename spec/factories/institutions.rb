FactoryBot.define do
  factory :institution do
    name { Faker::Company.name }
    trade_name { Faker::Company.buzzword }
    cnpj { CNPJ.generate(true) }
    external_member
  end
end
