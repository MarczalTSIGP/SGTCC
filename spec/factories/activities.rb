FactoryBot.define do
  sequence(:activity_calendar_year) { |n| (2100 + n).to_s }

  factory :activity do
    sequence(:name) { |n| "activity#{n}" }
    tcc { BaseActivity.tccs.values.sample }
    identifier { Activity.human_tcc_identifiers.values.sample }
    initial_date { Faker::Date.backward(days: 1) }
    final_date { Faker::Date.forward(days: 2) }
    base_activity_type
    calendar { association(:calendar, year: generate(:activity_calendar_year), tcc:) }

    judgment { true }

    trait :tcc_one do
      tcc { Activity.tccs.values.first }
    end

    trait :tcc_two do
      tcc { Activity.tccs.values.last }
    end

    trait :proposal do
      tcc { Activity.tccs.values.first }
      identifier { :proposal }
    end

    trait :project do
      tcc { Activity.tccs.values.first }
      identifier { :project }
    end

    trait :monograph do
      tcc { Activity.tccs.values.last }
      identifier { :monograph }
    end
  end
end
