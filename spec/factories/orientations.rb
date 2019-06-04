FactoryBot.define do
  factory :orientation do
    title { Faker::Lorem.sentence(3) }
    advisor { create(:professor) }
    calendar
    academic
    institution
    renewal_justification { Faker::Lorem.sentence(3) }

    factory :orientation_tcc_one do
      calendar { create(:calendar_tcc_one) }
    end

    factory :orientation_tcc_two do
      calendar { create(:calendar_tcc_two) }
    end

    factory :current_orientation_tcc_one do
      calendar { create(:current_calendar_tcc_one) }
    end

    factory :current_orientation_tcc_two do
      calendar { create(:current_calendar_tcc_two) }
    end

    factory :orientation_renewed do
      status { 'RENEWED' }
    end
  end
end
