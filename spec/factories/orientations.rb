FactoryBot.define do
  factory :orientation do
    title { Faker::Lorem.sentence(3) }
    advisor { create(:professor) }
    calendar
    academic
    institution

    factory :orientation_tcc_one do
      calendar { create(:calendar_tcc_one) }
    end

    factory :orientation_tcc_two do
      calendar { create(:calendar_tcc_two) }
    end
  end
end
