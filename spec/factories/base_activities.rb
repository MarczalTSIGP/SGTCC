FactoryBot.define do
  factory :base_activity do
    sequence(:name) { |n| "activity#{n}" }
    tcc { BaseActivity.tccs.values.sample }
    base_activity_type

    factory :base_activity_tcc_one do
      tcc { BaseActivity.tccs.values.first }
    end

    factory :base_activity_tcc_two do
      tcc { BaseActivity.tccs.values.last }
    end
  end
end
