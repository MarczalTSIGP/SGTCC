FactoryBot.define do
  factory :examination_board do
    date { Faker::Date.forward(1) }
    place { Faker::Address.community }
    orientation
  end
end
