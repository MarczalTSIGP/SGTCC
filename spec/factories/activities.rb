FactoryBot.define do
  factory :activity do
    sequence(:name) { |n| "activity#{n}" }
    tcc { BaseActivity.tccs.values.sample }
    initial_date { Faker::Date.forward(1) }
    final_date { Faker::Date.forward(2) }
    base_activity_type
    calendar

    factory :activity_tcc_one do
      tcc { Activity.tccs.values.first }
    end

    factory :activity_tcc_two do
      tcc { Activity.tccs.values.last }
    end
  end
end
