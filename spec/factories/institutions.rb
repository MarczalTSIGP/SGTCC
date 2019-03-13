require 'cpf_cnpj'

FactoryBot.define do
  factory :institution do
    name { Faker::Company.name }
    trade_name { Faker::Company.buzzword }
    cnpj { CNPJ.generate }
    external_member
  end
end
