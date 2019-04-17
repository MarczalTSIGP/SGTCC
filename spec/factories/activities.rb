FactoryBot.define do
  factory :activity do
    sequence(:name) { |n| "activity#{n}" }
    tcc { BaseActivity.tccs.values.sample }
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
