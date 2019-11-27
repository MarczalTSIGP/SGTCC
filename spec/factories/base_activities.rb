FactoryBot.define do
  factory :base_activity do
    sequence(:name) { |n| "base_activity#{n}" }
    tcc { BaseActivity.tccs.values.sample }
    identifier { BaseActivity.human_tcc_identifiers.values.sample }
    base_activity_type
    judgment { true }

    factory :base_activity_tcc_one do
      tcc { BaseActivity.tccs.values.first }
    end

    factory :base_activity_tcc_two do
      tcc { BaseActivity.tccs.values.last }
    end
  end
end
